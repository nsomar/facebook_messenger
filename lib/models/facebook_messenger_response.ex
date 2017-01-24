defmodule FacebookMessenger.Response do
  @moduledoc """
  Facebook messenger response structure
  """

  @derive [Poison.Encoder]
  @postback_regex ~r/postback/
  defstruct [:object, :entry]

  @doc """
  Decode a map into a `FacebookMessenger.Response`
  """
  @spec parse(map) :: FacebookMessenger.Response.t

  def parse(param) when is_map(param) do
    Poison.Decode.decode(param, as: decoder(param))
  end

  @doc """
  Decode a string into a `FacebookMessenger.Response`
  """
  @spec parse(String.t) :: FacebookMessenger.Response.t
  def parse(param) when is_binary(param) do
    Poison.decode!(param, as: decoder(param))
  end

  @doc """
  Return an list of message texts from a `FacebookMessenger.Response`
  """
  @spec message_texts(FacebookMessenger.Response) :: [String.t]
  def message_texts(%{entry: entries}) do
    messaging =
      entries
      |> get_messaging_struct
      |> Enum.map(&( &1 |> Map.get(:message)
      |> Map.get(:text)))
  end

  defp decoder(param) do
    param
      |> FacebookMessenger.MessageParsers.get_parser
      |> decoding_map
  end

  @doc """
  Return an list of message sender Ids from a `FacebookMessenger.Response`
  """
  @spec message_senders(FacebookMessenger.Response) :: [String.t]
  def message_senders(%{entry: entries}) do
    entries
    |> get_messaging_struct
    |> Enum.map(&( &1 |> Map.get(:sender) |> Map.get(:id)))
  end

  defp get_messaging_struct(entries, messaging_key \\ :messaging) do
    Enum.flat_map(entries, &Map.get(&1, messaging_key))
  end

  defp decoding_map(messaging_parser) do
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
