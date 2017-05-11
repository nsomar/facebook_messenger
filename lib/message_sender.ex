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

  @doc """
  sends a message to the the recipient

  * :recipient - the recipient to send the message to
  * :message - the message to send
  """
  @spec send(String.t, String.t) :: HTTPotion.Response.t
  def send(recipient, message) do
    post_to_recipient(recipient, %{message: %{text: message}})
  end

  @doc """
  sends an image message to the recipient

  * :recipient - the recipient to send the message to
  * :image_url - the url of the image to be sent
  """
  @spec send_image(String.t, String.t) :: HTTPotion.Response.t
  def send_image(recipient, image_url) do
    payload =
      %{message:
        %{attachment:
          %{type: "image",
            payload: %{url: image_url}}
        }}
    post_to_recipient(recipient, payload)
  end

  @doc """
  return the url to hit to send the message
  """
  def url do
    query = "access_token=#{page_token}"
    "https://graph.facebook.com/v2.6/me/messages?#{query}"
  end

  defp page_token do
    Application.get_env(:facebook_messenger, :facebook_page_token)
  end

  defp manager do
    Application.get_env(:facebook_messenger, :request_manager) || FacebookMessenger.RequestManager
  end
end
