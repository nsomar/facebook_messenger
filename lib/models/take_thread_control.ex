defmodule FacebookMessenger.TakeThreadControl do
  @moduledoc """
    Facebook take_thread_control structure
  """

  @derive [Poison.Encoder]
  defstruct [:metadata, :previous_owner_app_id]

  @type t :: %FacebookMessenger.TakeThreadControl{
          metadata: String.t(),
          previous_owner_app_id: String.t()
        }
end
