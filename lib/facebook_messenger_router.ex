defmodule FacebookMessenger.Router do
  @behaviour Plug
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, opts) do
    case conn.method do
      "GET" -> do_challenge(conn, endpoint, opts)
      "POST" -> do_message(conn, endpoint, opts)
    end
  end

  defp do_challenge(%{request_path: path} = conn, endpoint, opts)
  when path != endpoint and endpoint != nil do
    inform_challange(Keyword.get(opts, :challange_failed))
    send_resp(conn, 500, "")
  end

  defp do_challenge(conn, _, opts) do

    conn = fetch_query_params(conn)
    case FacebookMessenger.check_challenge(conn.query_params) do
      {:ok, challange} ->
        inform_challange(Keyword.get(opts, :challange_succeeded))
        send_resp(conn, 200, challange)
      _ ->
        inform_challange(Keyword.get(opts, :challange_failed))
        send_resp(conn, 500, "")
    end
  end

  defp do_message(%{request_path: path} = conn, endpoint, _)
  when path != endpoint and endpoint != nil do
    send_resp(conn, 500, "")
  end

  defp do_message(conn, _, opts) do
    {:ok, body, conn} = read_body(conn)

    case FacebookMessenger.parse_message(body) do
      {:ok, message} ->
        inform_message(Keyword.get(opts, :message_received), message)
        send_resp(conn, 200, "")
      _ ->
        send_resp(conn, 500, "")
    end
  end

  defp endpoint, do: Application.get_env(:facebook_messenger, :endpoint)

  defp inform_challange(challange) when challange != nil do
    challange.()
  end
  defp inform_challange(_), do: nil

  defp inform_message(received, message) when received != nil do
    received.(message)
  end
  defp inform_message(_, _), do: nil

end
