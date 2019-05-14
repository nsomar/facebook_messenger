defmodule FacebookMessenger.PassThreadControl do
  @moduledoc """
    Facebook request_thread_control structure
  """

  @derive [Poison.Encoder]
  defstruct [:metadata, :new_owner_app_id]

  @type t :: %FacebookMessenger.PassThreadControl{
          metadata: String.t(),
          new_owner_app_id: String.t()
        }
end
