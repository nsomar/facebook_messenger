defmodule FacebookMessenger.Postback do
  @moduledoc """
    Facebook postback structure
  """

  @derive [Poison.Encoder]
  defstruct [:payload, :referral]

  @type t :: %FacebookMessenger.Postback{
    payload: String.t,
    referral: FacebookMessenger.Referral
  }
end
