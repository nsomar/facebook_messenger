defmodule FacebookMessenger.Controller do
  @moduledoc """
  Module that defines the basic methods required to be a facebook messanger bot

  This module defines methods to handle facebook messanger authentication challange
  and facebook webhook callbacks
  """

  defmacro __using__(x) do
    quote do
      use Phoenix.Controller
      require Logger
      @behaviour FacebookMessenger.Callback

      @callback_handler __MODULE__

      def challange(conn,
                %{"hub.mode" => "subscribe",
                "hub.verify_token" => token,
                "hub.challenge" => challenge} = params) do

        Logger.info "token #{token}"
        Logger.info "verify_token #{verify_token}"

        case token == verify_token do
          true ->
            inform_callback(:challange_successfull, [params])
            respond.(&json/2, conn, String.to_integer(challenge))
          _ ->
            inform_callback(:challange_failed, [params])
            invalid_token(conn, params)
        end
      end

      def challange(conn, params), do: invalid_token(conn, params)

      def webhook(conn, %{"object" => "page"} = params) do
        response = FacebookMessenger.Response.parse(params)
        Logger.info("Recevied messsages #{inspect(response)}")

        @callback_handler.message_received(response)

        conn = put_status(conn, 200)
        respond.(&json/2, conn, "")
      end

      def webhook(conn, params) do
        Logger.info("Webhook bad request #{inspect(conn)} \n\n\nWith params #{inspect(params)}")

        conn= put_status(conn, 500)
        respond.(&json/2, conn, "")
      end

      defp verify_token, do: Application.get_env(:facebook_messenger, :challange_verification_token)

      defp invalid_token(conn, params) do
        Logger.error("Bad request #{inspect(conn)} with params #{inspect(params)}")

        conn = put_status(conn, 500)
        respond.(&json/2, conn, %{error: %{
                  path: conn.request_path,
                  params: params
                  }})
      end

      defp respond do
        &responder.respond/3
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
