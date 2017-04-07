
defmodule TestBotOne.MessageSenderTest do
  use ExUnit.Case

  test "creates a correct url" do
    assert FacebookMessenger.Sender.url == "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"
  end

  test "creates a correct payload" do
    assert FacebookMessenger.Sender.payload(1055439761215256, "Hello") ==
    %{message: %{text: "Hello"}, recipient: %{id: 1055439761215256}}
  end

  test "converts hash to json"do
    assert FacebookMessenger.Sender.to_json(%{test_key: "test_value"}) ==
    "{\"test_key\":\"test_value\"}"
  end

  test "sends correct message" do
    FacebookMessenger.Sender.send(1055439761215256, "Hello")
    assert_received %{body: "{\"recipient\":{\"id\":1055439761215256},\"message\":{\"text\":\"Hello\"}}", url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"}
  end
end
