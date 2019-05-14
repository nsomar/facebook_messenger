defmodule FacebookMessenger.Messaging do
  @moduledoc """
  Facebook messaging structure, contains the sender, recepient and message info
  """
  @derive [Poison.Encoder]
  defstruct [
    :sender,
    :recipient,
    :timestamp,
    :message,
    :postback,
    :type,
    :referral,
    :request_thread_control,
    :take_thread_control,
    :pass_thread_control,
    :app_roles
  ]

  @type t :: %FacebookMessenger.Messaging{
          type: String.t(),
          sender: FacebookMessenger.User.t(),
          recipient: FacebookMessenger.User.t(),
          timestamp: integer,
          message: FacebookMessenger.Message.t(),
          referral: FacebookMessenger.Referral.t(),
          request_thread_control: FacebookMessenger.Referral.RequestThreadControl.t(),
          take_thread_control: FacebookMessenger.Referral.TakeThreadControl.t(),
          pass_thread_control: FacebookMessenger.Referral.PassThreadControl.t(),
          app_roles: Map.t()
        }
end
