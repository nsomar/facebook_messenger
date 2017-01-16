defmodule FacebookMessenger.Entry do
  @moduledoc """
  Facebook entry structure
  """
  @derive [Poison.Encoder]
  defstruct [:id, :time, :messaging]

  @type t :: %FacebookMessenger.Entry{
    id: String.t,
    messaging: FacebookMessenger.Messaging.t,
    time: integer
  }
end