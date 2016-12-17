defmodule FacebookMessenger.Response do
  @moduledoc """
  Facebook messenger response structure
  """

  @derive [Poison.Encoder]
  defstruct [:object, :entry]

  @doc """
  Decode a map into a `FacebookMessenger.Response`
  """
  @spec parse(map) :: FacebookMessenger.Response.t

  def parse(param) when is_map(param) do
    Poison.Decode.decode(param, as: decoding_map)
  end

  @doc """
  Decode a string into a `FacebookMessenger.Response`
  """
  @spec parse(String.t) :: FacebookMessenger.Response.t

  def parse(param) when is_binary(param) do
    Poison.decode!(param, as: decoding_map)
  end

  @doc """
  Retrun an list of message texts from a `FacebookMessenger.Response`
  """
  @spec message_texts(FacebookMessenger.Response) :: [String.t]
  def message_texts(%{entry: entries}) do
    messaging =
    Enum.flat_map(entries, &Map.get(&1, :messaging))
    |> Enum.map(&( &1 |> Map.get(:message) |> Map.get(:text)))
  end

  @doc """
  Retrun an list of message sender Ids from a `FacebookMessenger.Response`
  """
  @spec message_senders(FacebookMessenger.Response) :: [String.t]
  def message_senders(%{entry: entries}) do
    messaging =
    Enum.flat_map(entries, &Map.get(&1, :messaging))
    |> Enum.map(&( &1 |> Map.get(:sender) |> Map.get(:id)))
  end


  defp decoding_map do
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

   @type t :: %FacebookMessenger.Response{
    object: String.t,
    entry: FacebookMessenger.Entry.t
  }

end
