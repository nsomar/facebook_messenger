defmodule FacebookMessenger.Response.User do
  @moduledoc """
  Facebook user structure
  """

  @derive [Poison.Encoder]
  defstruct [:id]

  @type t :: %FacebookMessenger.Response.User{
    id: String.t
  }
end