defmodule FacebookMessenger.Response.Message do
  @moduledoc """
  Facebook message structure
  """

  @derive [Poison.Encoder]
  defstruct [:mid, :seq, :text]

  @type t :: %FacebookMessenger.Response.Message{
    mid: String.t,
    seq: integer,
    text: String.t
  }
end