defmodule FacebookMessenger.MessageParsers do
  def get_parser(param) when is_binary(param) do
    cond do
      String.match?(param, @postback_regex) -> postback_parser
      true -> text_message_parser
    end
  end

  def get_parser(%{"entry" => entries} = param) when is_map(param) do
    messaging = entries |> get_messaging_struct("messaging") |> hd

    cond do
      is_postback?(param) -> postback_parser
      is_message?(param) -> text_message_parser
    end
  end

  defp is_postback?(messaging) when is_map(param) do
    Map.has_key?(messaging, "postback")
  end

  defp is_message?(messaging) when is_map(param) do
    Map.has_key?(messaging, "message")
  end

  defp postback_parser do
    %FacebookMessenger.Messaging{
      "type": "postback",
      "sender": %FacebookMessenger.User{},
      "recipient": %FacebookMessenger.User{},
      "postback": %FacebookMessenger.Postback{}
    }
  end

  defp text_message_parser do
    %FacebookMessenger.Messaging{
      "type": "message",
      "sender": %FacebookMessenger.User{},
      "recipient": %FacebookMessenger.User{},
      "message": %FacebookMessenger.Message{}
    }
  end
end