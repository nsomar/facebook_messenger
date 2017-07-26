defmodule FacebookMessenger.Response.Referral do
  @moduledoc """
    Facebook referral structure
  """

  @derive [Poison.Encoder]
  defstruct [:ref, :source, :type]

  @type t :: %FacebookMessenger.Response.Referral{
    ref: String.t,
    source: String.t,
    type: String.t
  }
end
