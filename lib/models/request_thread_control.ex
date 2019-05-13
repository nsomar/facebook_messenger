defmodule FacebookMessenger.RequestThreadControl do
  @moduledoc """
    Facebook request_thread_control structure
  """

  @derive [Poison.Encoder]
  defstruct [:metadata, :requested_owner_app_id]

  @type t :: %FacebookMessenger.RequestThreadControl{
          metadata: String.t(),
          requested_owner_app_id: String.t()
        }
end
