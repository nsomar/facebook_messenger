defmodule FacebookMessenger.Profile do
  @moduledoc """
  Managing the bot's profile
  """
  require Logger

  def set_get_started_button(payload \\ "GET_STARTED") do
    post(%{get_started: %{payload: payload}})
  end

  defp post(body) do
    manager.post(
      url: url,
      body: Poison.encode!(body)
    )
  end

  @doc """
  return the url to hit to send the message
  """
  def url do
    query = "access_token=#{page_token}"
    "https://graph.facebook.com/v2.6/me/messenger_profile?#{query}"
  end

  defp page_token do
    Application.get_env(:facebook_messenger, :facebook_page_token)
  end

  defp manager do
    Application.get_env(:facebook_messenger, :request_manager) || FacebookMessenger.RequestManager
  end
end
