defmodule FacebookMessenger.Messaging do
  @moduledoc """
  Facebook messaging structure, contains the sender, recepient and message info
  """
  @derive [Poison.Encoder]
  defstruct [:sender, :recipient, :timestamp, :message]

  @type t :: %FacebookMessenger.Messaging{
    sender: FacebookMessenger.User.t,
    recipient: FacebookMessenger.User.t,
    timestamp: integer,
    message: FacebookMessenger.Message.t
  }
end