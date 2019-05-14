defmodule FacebookMessenger.Message do
  @moduledoc """
  Facebook message structure
  """

  @derive [Poison.Encoder]
  defstruct [:mid, :seq, :text, :attachments]

  @type t :: %FacebookMessenger.Message{
          mid: String.t(),
          seq: integer,
          text: String.t(),
          attachments: [Map.t()]
        }
end
