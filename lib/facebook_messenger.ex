
defmodule FacebookMessenger.Messaging do
  @derive [Poison.Encoder]
  defstruct [:sender, :recipient, :timestamp, :message]
end

defmodule FacebookMessenger.Message do
  @derive [Poison.Encoder]
  defstruct [:mid, :seq, :text]
end

defmodule FacebookMessenger.User do
  @derive [Poison.Encoder]
  defstruct [:id]
end

defmodule FacebookMessenger.Entry do
  @derive [Poison.Encoder]
  defstruct [:id, :time, :messaging]
end

defmodule FacebookMessenger.Response do
  @derive [Poison.Encoder]
  defstruct [:object, :entry]

  def parse(param) when is_map(param) do
    Poison.Decode.decode(param, as: decoding_map)
  end

  def parse(param) when is_binary(param) do
    Poison.decode!(param, as: decoding_map)
  end

  def decoding_map do
     messaging_parser =
    %FacebookMessenger.Messaging{
      "sender": %FacebookMessenger.User{},
      "recipient": %FacebookMessenger.User{},
      "message": %FacebookMessenger.Message{},
    }
    %FacebookMessenger.Response{
      "entry": [%FacebookMessenger.Entry{
        "messaging": [messaging_parser]
      }]}
  end
end
