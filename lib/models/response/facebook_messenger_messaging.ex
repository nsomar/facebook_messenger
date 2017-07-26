defmodule FacebookMessenger.Response.Messaging do
  @moduledoc """
  Facebook messaging structure, contains the sender, recepient and message info
  """
  @derive [Poison.Encoder]
  defstruct [:sender, :recipient, :timestamp, :message, :postback, :type]

  @type t :: %FacebookMessenger.Response.Messaging{
    type: String.t,
    sender: FacebookMessenger.Response.User.t,
    recipient: FacebookMessenger.Response.User.t,
    timestamp: integer,
    message: FacebookMessenger.Response.Message.t
  }
end