defmodule FacebookMessenger.Controller do

  # @callback message_received() :: Any
  # @callback challange(token :: String.t) :: booblean

  defmacro __using__(_) do
    quote do
      use Phoenix.Controller
      require Logger

      def challange(conn,
                %{"hub.mode" => "subscribe",
                "hub.verify_token" => token,
                "hub.challenge" => challenge} = params) do

        Logger.info "token #{token}"
        Logger.info "verify_token #{verify_token}"

        cond do
          token == verify_token ->
            json conn, String.to_integer(challenge)
          true ->
            invalid_token(conn, params)
        end
      end

      def challange(conn, params), do: invalid_token(conn, params)

      def webhook(conn, %{"entry" => entries, "object" => "page"}) do
        messaging =
        Enum.flat_map(entries, &get_in(&1, ["messaging"]))
        |> Enum.map(fn message ->
          {get_in(message, ["sender", "id"]), get_in(message, ["message", "text"])}
        end)
        |> hd

        Logger.info("Recevied messsages #{inspect(messaging)}")
        {sender, message} = messaging

        FacebookMessenger.Sender.send(sender, message)

        conn
        |> put_status(200)
        |> json("")
      end

      def webhook(conn, params) do
        Logger.info("WEBHOOK #{inspect(conn)} \n\n\nWith params #{inspect(params)}")

        conn
        |> put_status(500)
        |> json(1)
      end

      def verify_token, do: Application.get_env(:facebook_messenger, :challange_verification_token)

      def invalid_token(conn, params) do
        Logger.error("Bad request #{inspect(conn)} with params #{inspect(params)}")
        conn
        |> put_status(500)
        |> json(%{error:
                %{
                  path: conn.request_path,
                  params: params
                  }})
      end

    end
  end
end
