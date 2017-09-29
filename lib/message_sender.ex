defmodule FacebookMessenger.Sender do
  @moduledoc """
  Module responsible for communicating back to facebook messenger
  """
  require Logger

  @doc """
  set sender action

  * :recipient - the recipient to send the action to
  * :sender_action - :mark_seen, :typing_on or :typing_off
  """
  def sender_action(recipient, sender_action) do
    post_to_recipient(recipient, %{sender_action: sender_action})
  end

  defp post_to_recipient(recipient, payload) do
    body = Map.put(payload, :recipient, %{id: recipient})
    manager.post(
      url: url,
      body: Poison.encode!(body)
    )
  end

  ## messenger profile API

  def get_messenger_profile(fields) do
    manager.get(
      url: url("messenger_profile", fields: (Enum.join(fields, ",")))
    )
  end

  def remove_messenger_profile(fields) do
    manager.delete(
      url: url("messenger_profile"),
      body: Poison.encode!(%{fields: fields})
    )
  end

  def set_messenger_profile(payload) do
    manager.post(
      url: url("messenger_profile"),
      body: Poison.encode!(payload)
    )
  end

  ## set

  @doc """
  sends a message to the the recipient

  * :recipient - the recipient to send the message to
  * :message - the message to send
  * :quick_replies - list of quick replies

  https://developers.facebook.com/docs/messenger-platform/send-api-reference/quick-replies
  """
  @spec send(String.t, String.t, [map()]) :: HTTPotion.Response.t
  def send(recipient, message, quick_replies \\ nil) do
    payload = %{message: %{text: message}}
    payload =
      case is_list(quick_replies) do
        true ->
          put_in(payload, [:message, :quick_replies], quick_replies)
        false ->
          payload
      end
    post_to_recipient(recipient, payload)
  end

  @doc """
  sends an image message to the recipient

  * :recipient - the recipient to send the message to
  * :image_url - the url of the image to be sent
  """
  @spec send_image(String.t, String.t) :: HTTPotion.Response.t
  def send_image(recipient, image_url) do
    send_content(recipient, "image", image_url)
  end

  @doc """
  sends a content item to the URL

  * :recipient - the recipient to send the message to
  * :content_type - audio | file | image | video
  * :content_url - the url of the content
  """
  @spec send_content(String.t, String.t, String.t) :: HTTPotion.Response.t
  def send_content(recipient, content_type, content_url) do
    payload = %{url: content_url}
    send_attachment(recipient, content_type, payload)
  end

  @doc """
  sends a template to the recipient

  * :recipient - the recipient to send the message to
  * :template - the template payload
  """
  @spec send_image(String.t, Map.t) :: HTTPotion.Response.t
  def send_template(recipient, template) do
    send_attachment(recipient, "template", template)
  end

  @doc """
  send a generic attachment

  * :recipient - the recipient to send the message to
  * :attachment - map with attachment information

  """
  @spec send_attachment(String.t, String.t, Map.t) :: HTTPotion.Response.t
  def send_attachment(recipient, type, payload) do
    attachment = %{type: type, payload: payload}
    payload = %{message: %{attachment: attachment}}
    post_to_recipient(recipient, payload)
  end

  @doc """
  return the url to hit to send the message
  """
  def url(endpoint \\ "messages", params \\ []) do
    query = URI.encode_query([{:access_token, page_token()} | params])
    "https://graph.facebook.com/v2.6/me/#{endpoint}?#{query}"
  end

  defp page_token do
    manager().page_token()
  end

  defp manager do
    Application.get_env(:facebook_messenger, :request_manager) || FacebookMessenger.RequestManager
  end
end
