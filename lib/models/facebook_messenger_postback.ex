defmodule FacebookMessenger.Postback do
  @moduledoc """
    Facebook postback structure
  """

  @derive [Poison.Encoder]
  defstruct [:payload]

  @type t :: %FacebookMessenger.Postback{
    payload: String.t
  }
end
