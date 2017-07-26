defmodule FacebookMessenger.Request.Button do
  @moduledoc """
    Facebook postback structure
  """

  @derive [Poison.Encoder]
  defstruct type: "postback", title: "", payload: ""

  @type t :: %FacebookMessenger.Request.Button{
    type: String.t,
    title: String.t,
    payload: String.t
  }
end
