defmodule FacebookMessenger.Response.Postback do
  @moduledoc """
    Facebook postback structure
  """

  @derive [Poison.Encoder]
  defstruct [:payload, :referral]

  @type t :: %FacebookMessenger.Response.Postback{
    payload: String.t,
    referral: FacebookMessenger.Response.Referral
  }
end
