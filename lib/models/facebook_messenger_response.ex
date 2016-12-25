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
    decoder = param |> get_parser |> decoding_map
    Poison.Decode.decode(param, as: decoder)
  end

  @doc """
  Decode a string into a `FacebookMessenger.Response`
  """
  @spec parse(String.t) :: FacebookMessenger.Response.t

  def parse(param) when is_binary(param) do
    decoder = param |> get_parser |> decoding_map
    Poison.decode!(param, as: decoder)
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
  Return an list of message sender Ids from a `FacebookMessenger.Response`
  """
  @spec message_senders(FacebookMessenger.Response) :: [String.t]
  def message_senders(%{entry: entries}) do
    messaging =
    entries
    |> get_messsaging
    |> Enum.map(&( &1 |> Map.get(:sender) |> Map.get(:id)))
  end

  @doc """
  Return user defined postback payload from a `FacebookMessenger.Response`
  """
  @spec get_postback(FacebookMessenger.Response) :: FacebookMessenger.Postback.t
  def get_postback(%{entry: entries}) do
    postback =
      entries
      |> get_messsaging
      |> Enum.map(&Map.get(&1, :postback))
      |> hd
  end

  defp get_parser(param) when is_binary(param) do
    cond do
      String.match?(param, @postback_regex) -> postback_parser
      true -> text_message_parser
    end
  end

  defp get_parser(%{"entry" => entries})  do

    map = entries |> get_messsaging |> hd

    cond do
      Map.has_key?(map, "postback") -> postback_parser
      Map.has_key?(map, "message") -> text_message_parser
      true -> text_message_parser
    end
  end

  defp get_messsaging(entries) do
    Enum.flat_map(entries, &Map.get(&1, :messaging))
  end

  defp postback_parser do
    %FacebookMessenger.Messaging{
      "sender": %FacebookMessenger.User{},
      "recipient": %FacebookMessenger.User{},
      "postback": %FacebookMessenger.Postback{}
    }
  end

  defp text_message_parser do
    %FacebookMessenger.Messaging{
      "sender": %FacebookMessenger.User{},
      "recipient": %FacebookMessenger.User{},
      "message": %FacebookMessenger.Message{}
    }
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
