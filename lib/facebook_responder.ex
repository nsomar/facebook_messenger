
defmodule FacebookMessenger.Responder do
  @moduledoc """
  Module responsilbe for responding back to phoenix plug
  """
  def respond(type, conn, response) do
    type.(conn, response)
  end
end

defmodule FacebookMessenger.Responder.Mock do
  @moduledoc """
  Mock Module responsilbe for responding back to phoenix plug
  """
  def respond(type, conn, response) do
    send(self, {conn.request_path, response})
  end
end
