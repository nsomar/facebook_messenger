defmodule FacebookMessenger do
  @moduledoc """
  Module responsible to check the facebook messenger webhook registation and responsible for
  dealing with facebook messages
  """
  require Logger

  @doc """
  Check if the challenge sent from facebook matches the one stored in the app
  The stored verification token is configured by setting `challenge_verification_token` in config.exs

  Parameters:

  - `params`: Parameters sent from facebook
  """
  def check_challenge(%{"hub.mode" => "subscribe",
                        "hub.verify_token" => token,
                        "hub.challenge" => challenge} = params) do

    Logger.info "token #{token}"
    Logger.info "verify_token #{verify_token}"

    case token == verify_token do
      true -> {:ok, challenge}
      _ -> :error
    end
  end

  def check_challenge(params), do: :error

  @doc """
  Parse the payload sent from facebook and converts them to `FacebookMessenger.Response` structure

  Parameters:

  - `params`: Parameters sent from facebook
  """
  def parse_message(params) when is_bitstring(params) do
    response = FacebookMessenger.Response.parse(params)
    Logger.info("Recevied messsages #{inspect(response)}")

    {:ok, response}
  end

  def parse_message(%{"object" => "page"} = params) do
    response = FacebookMessenger.Response.parse(params)
    Logger.info("Recevied messsages #{inspect(response)}")

    {:ok, response}
  end

  def parse_message(params) do
    Logger.info("Webhook bad request with params #{inspect(params)}")
    :error
  end

  defp verify_token, do: Application.get_env(:facebook_messenger, :challenge_verification_token)
end
