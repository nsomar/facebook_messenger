defmodule FacebookMessenger.Controller.Test do
  use ExUnit.Case

  test "it returns the passed challenge if token matches" do
    challenge = %{"hub.mode" => "subscribe",
                "hub.verify_token" => "VERIFY_TOKEN",
                "hub.challenge" => "1234567"}
    assert FacebookMessenger.check_challenge(challenge) == {:ok, "1234567"}
  end

  test "it returns error if webhook token does not match" do
    challenge = %{"hub.mode" => "subscribe",
                  "hub.verify_token" => "1",
                  "hub.challenge" => "1234567"}
    assert FacebookMessenger.check_challenge(challenge) == :error
  end

  test "it gets the callback successful event" do
    challenge = %{"hub.mode" => "subscribe",
                  "hub.verify_token" => "VERIFY_TOKEN",
                  "hub.challenge" => "1234567"}
    assert FacebookMessenger.check_challenge(challenge) == {:ok, "1234567"}
  end

  test "it returns error if webhook is not valid" do
    assert FacebookMessenger.check_challenge(1) == :error
  end

  test "it receives a message" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")
    {:ok, json} = file |> Poison.decode

    assert FacebookMessenger.parse_message(json) == {:ok,
            %FacebookMessenger.Response{entry: [%FacebookMessenger.Entry{id: "PAGE_ID",
               messaging: [%FacebookMessenger.Messaging{
                type: "message",
                message: %FacebookMessenger.Message{mid: "mid.1460245671959:dad2ec9421b03d6f78",
                  seq: 216, text: "hello"},
                 recipient: %FacebookMessenger.User{id: "PAGE_ID"},
                 sender: %FacebookMessenger.User{id: "USER_ID"},
                 timestamp: 1460245672080}], time: 1460245674269}],
             object: "page"}}
  end

  test "it receives a message in string" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")

    assert FacebookMessenger.parse_message(file) == {:ok,
            %FacebookMessenger.Response{entry: [%FacebookMessenger.Entry{id: "PAGE_ID",
               messaging: [%FacebookMessenger.Messaging{type: "message",
                  message: %FacebookMessenger.Message{mid: "mid.1460245671959:dad2ec9421b03d6f78",
                  seq: 216, text: "hello"},
                 recipient: %FacebookMessenger.User{id: "PAGE_ID"},
                 sender: %FacebookMessenger.User{id: "USER_ID"},
                 timestamp: 1460245672080}], time: 1460245674269}],
             object: "page"}}
  end

  test "it handles bad messages" do
    assert FacebookMessenger.parse_message(1) == :error
  end
end
