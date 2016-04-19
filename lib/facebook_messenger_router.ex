defmodule FacebookMessenger.Router do
  use Plug.Router

  plug Plug.Logger, level: :info

  plug :match
  plug :dispatch

  # get Application.get_env(:facebook_messenger, :endpoint) do

  # end

  # post Application.get_env(:facebook_messenger, :endpoint) do

  # end

  match _, via: :get do
    do_challenge(conn, endpoint)
  end

  match _, via: :post do
    do_message(conn, endpoint)
  end

  defp do_challenge(%{request_path: path} = conn, endpoint)
  when path != endpoint and endpoint != nil do
    send_resp(conn, 500, "")
  end

  defp do_challenge(conn, _) do
    conn = fetch_query_params(conn)
    case FacebookMessenger.check_challenge(conn.query_params) do
      {:ok, challange} ->
        send_resp(conn, 200, challange)
      _ ->
        send_resp(conn, 500, "")
    end
  end

  defp do_message(%{request_path: path} = conn, endpoint)
  when path != endpoint and endpoint != nil do
    send_resp(conn, 500, "")
  end

  defp do_message(conn, _) do
    {:ok, body, conn} = read_body(conn)

    case FacebookMessenger.parse_message(body) do
      {:ok, message} ->
        send_message(message)
        send_resp(conn, 200, "")
      _ ->
        send_resp(conn, 500, "")
    end
  end

  defp endpoint, do: Application.get_env(:facebook_messenger, :endpoint)

  defp send_message(msg) do
    text = FacebookMessenger.Response.message_texts(msg) |> hd
    sender = FacebookMessenger.Response.message_senders(msg) |> hd
    FacebookMessenger.Sender.send(sender, text)
  end
end
