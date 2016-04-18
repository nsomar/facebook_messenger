defmodule FacebookMessenger.Phoenix.Controller do
  @moduledoc """
  Module that defines the basic methods required to be a facebook messanger bot

  This module defines methods to handle facebook messanger authentication challenge
  and facebook webhook callbacks
  """

  defmacro __using__(x) do
    quote do
      require Logger
      use Phoenix.Controller
      import FacebookMessenger.Controller
      @behaviour FacebookMessenger.Callback

      @callback_handler __MODULE__

      def challenge(conn, params) do
        case check_challenge(params) do
          {:ok, challenge} ->
            inform_callback(:challenge_successfull, [params])
            conn = resp(conn, 200, challenge)
            respond.(conn)
          _ ->
            inform_callback(:challenge_failed, [params])
            invalid_token(conn, params)
        end
      end

      def webhook(conn, params) do
        params
        |> parse_message
        |> inform_and_reply(conn)
      end

      def inform_and_reply({:ok, message}, conn) do
        @callback_handler.message_received(message)

        conn = resp(conn, 200, "")
        respond.(conn)
      end

      def inform_and_reply({:error}, conn) do
        conn = resp(conn, 500, "")
        respond.(conn)
      end

      defp invalid_token(conn, params) do
        Logger.error("Bad request #{inspect(conn)} with params #{inspect(params)}")

        conn = resp(conn, 500, "")
        respond.(conn)
      end

      defp respond do
        &responder.respond/1
      end

      defp responder do
        Application.get_env(:facebook_messenger, :responder) || FacebookMessenger.Responder
      end

      defp inform_callback(event, params) do
        case @callback_handler.__info__(:functions)[event] do
          nil ->
            nil
          _ ->
            apply(@callback_handler, event, params)
        end
      end

    end
  end
end
