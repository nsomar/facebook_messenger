defmodule FacebookMessenger.Response.Entry do
  @moduledoc """
  Facebook entry structure
  """
  @derive [Poison.Encoder]
  defstruct [:id, :time, :messaging]

  @type t :: %FacebookMessenger.Response.Entry{
    id: String.t,
    messaging: FacebookMessenger.Response.Messaging.t,
    time: integer
  }
end