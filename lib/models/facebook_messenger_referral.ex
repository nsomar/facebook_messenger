defmodule FacebookMessenger.Referral do
  @moduledoc """
    Facebook referral structure
  """

  @derive [Poison.Encoder]
  defstruct [:ref, :source, :type]

  @type t :: %FacebookMessenger.Referral{
    ref: String.t,
    source: String.t,
    type: String.t
  }
end
