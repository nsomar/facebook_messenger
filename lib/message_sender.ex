defmodule FacebookMessenger.Sender do
  require Logger

  def send(sender, message) do
    res = manager.post(
      url: url,
      body: json_payload(sender, message)
    )
    Logger.info("response from FB #{inspect(res)}")
    res
  end

  def payload(sender, message) do
    %{
      recipient: %{id: sender},
      message: %{text: message}
    }
  end

  def json_payload(sender, message) do
    payload(sender, message)
    |> Poison.encode
    |> elem(1)
  end

  def url do
    query = "access_token=#{page_token}"
    "https://graph.facebook.com/v2.6/me/messages?#{query}"
  end

  def page_token do
    Application.get_env(:facebook_messenger, :facebook_page_token)
  end

  def manager do
    Application.get_env(:facebook_messenger, :request_manager) || FacebookMessenger.RequestManager
  end
end
