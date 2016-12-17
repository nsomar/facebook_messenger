defmodule FacebookMessenger.User do
  @moduledoc """
  Facebook user structure
  """

  @derive [Poison.Encoder]
  defstruct [:id]

  @type t :: %FacebookMessenger.User{
    id: String.t
  }
end