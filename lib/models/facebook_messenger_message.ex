defmodule FacebookMessenger.Message do
  @moduledoc """
  Facebook message structure
  """

  @derive [Poison.Encoder]
  defstruct [:mid, :seq, :text]

  @type t :: %FacebookMessenger.Message{
    mid: String.t,
    seq: integer,
    text: String.t
  }
end