
defmodule FacebookMessenger.Responder do
  @moduledoc """
  Module responsilbe for responding back to phoenix plug
  """
  def respond(conn) do
    Plug.Conn.send_resp(conn)
  end
end

defmodule FacebookMessenger.Responder.Mock do
  @moduledoc """
  Mock Module responsilbe for responding back to phoenix plug
  """
  def respond(%{request_path: request_path, status: status, resp_body: resp_body}) do
    send(self, {request_path, status, resp_body})
  end
end
