defmodule FacebookMessenger.Message.Test do
  use ExUnit.Case

  test "text message gets initialized from a string" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")

    res = FacebookMessenger.Response.parse(file)
    assert is_list(res.entry) == true
    assert res.entry |> hd |> Map.get(:id) == "PAGE_ID"

    messaging = res.entry |> hd |> Map.get(:messaging)
    assert  messaging |> is_list == true
    assert  messaging |> hd |> Map.get(:sender) |> Map.get(:id) == "USER_ID"
    assert  messaging |> hd |> Map.get(:recipient) |> Map.get(:id) == "PAGE_ID"

    message = messaging |> hd |> Map.get(:message)
    assert message.text == "hello"
  end

  test "text message gets initialized from a json" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")
    {:ok, json} = file |> Poison.decode

    res = FacebookMessenger.Response.parse(json)
    assert is_list(res.entry) == true
    assert res.entry |> hd |> Map.get(:id) == "PAGE_ID"

    messaging = res.entry |> hd |> Map.get(:messaging)
    assert  messaging |> is_list == true
    assert  messaging |> hd |> Map.get(:sender) |> Map.get(:id) == "USER_ID"
    assert  messaging |> hd |> Map.get(:recipient) |> Map.get(:id) == "PAGE_ID"

    message = messaging |> hd |> Map.get(:message)
    assert message.text == "hello"
  end

  test "postback gets initialized from a json" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_postback.json")
    {:ok, json} = file |> Poison.decode

    res = FacebookMessenger.Response.parse(json)
    messaging = res |> FacebookMessenger.Response.get_messaging

    assert messaging.type == "postback"
    assert messaging.postback.payload == "USER_DEFINED_PAYLOAD"
  end

  test "referral gets initialized from a json" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_referral.json")
    {:ok, json} = file |> Poison.decode

    res = FacebookMessenger.Response.parse(json)
    messaging = res |> FacebookMessenger.Response.get_messaging

    assert messaging.type == "referral"
    assert messaging.referral.ref == "hello123"
    assert messaging.referral.source == "SHORTLINK"
    assert messaging.referral.type == "OPEN_THREAD"
  end

  test "text message gets the message text from the response" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")
    res = FacebookMessenger.Response.parse(file)
    res = FacebookMessenger.Response.message_texts(res)
    assert res == ["hello"]
  end

  test "postback gets the postback payload from the response" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_postback.json")

    postback =
      FacebookMessenger.Response.parse(file)
      |> FacebookMessenger.Response.get_postback

    assert postback.payload == "USER_DEFINED_PAYLOAD"
  end

  test "it gets the message sender id" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")
    res = FacebookMessenger.Response.parse(file)
    res = FacebookMessenger.Response.message_senders(res)
    assert res == ["USER_ID"]
  end
end
