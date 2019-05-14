defmodule FacebookMessenger.Message.Test do
  use ExUnit.Case

  test "text message gets initialized from a string" do
    IO.inspect(__DIR__, label: "__DIR__")

    {:ok, file} = File.read("#{__DIR__}/fixtures/messenger_response.json")

    res = FacebookMessenger.Response.parse(file)
    assert is_list(res.entry) == true
    assert res.entry |> hd |> Map.get(:id) == "PAGE_ID"

    messaging = res.entry |> hd |> Map.get(:messaging)
    assert messaging |> is_list == true
    assert messaging |> hd |> Map.get(:sender) |> Map.get(:id) == "USER_ID"
    assert messaging |> hd |> Map.get(:recipient) |> Map.get(:id) == "PAGE_ID"

    message = messaging |> hd |> Map.get(:message)
    assert message.text == "hello"
  end

  test "text message gets initialized from a json" do
    {:ok, file} = File.read("#{__DIR__}/fixtures/messenger_response.json")
    {:ok, json} = file |> Poison.decode()

    res = FacebookMessenger.Response.parse(json)
    assert is_list(res.entry) == true
    assert res.entry |> hd |> Map.get(:id) == "PAGE_ID"

    messaging = res.entry |> hd |> Map.get(:messaging)
    assert messaging |> is_list == true
    assert messaging |> hd |> Map.get(:sender) |> Map.get(:id) == "USER_ID"
    assert messaging |> hd |> Map.get(:recipient) |> Map.get(:id) == "PAGE_ID"

    message = messaging |> hd |> Map.get(:message)
    assert message.text == "hello"
  end

  test "postback gets initialized from a json" do
    {:ok, file} = File.read("#{__DIR__}/fixtures/messenger_postback.json")
    {:ok, json} = file |> Poison.decode()

    res = FacebookMessenger.Response.parse(json)
    messaging = res |> FacebookMessenger.Response.get_messaging()

    assert messaging.type == "postback"
    assert messaging.postback.payload == "USER_DEFINED_PAYLOAD"
  end

  test "referral gets initialized from a json" do
    {:ok, file} = File.read("#{__DIR__}/fixtures/messenger_referral.json")
    {:ok, json} = file |> Poison.decode()

    res = FacebookMessenger.Response.parse(json)
    messaging = res |> FacebookMessenger.Response.get_messaging()

    assert messaging.type == "referral"
    assert messaging.referral.ref == "hello123"
    assert messaging.referral.source == "SHORTLINK"
    assert messaging.referral.type == "OPEN_THREAD"
  end

  test "text message gets the message text from the response" do
    {:ok, file} = File.read("#{__DIR__}/fixtures/messenger_response.json")
    res = FacebookMessenger.Response.parse(file)
    res = FacebookMessenger.Response.message_texts(res)
    assert res == ["hello"]
  end

  test "postback gets the postback payload from the response" do
    {:ok, file} = File.read("#{__DIR__}/fixtures/messenger_postback.json")

    postback =
      FacebookMessenger.Response.parse(file)
      |> FacebookMessenger.Response.get_postback()

    assert postback.payload == "USER_DEFINED_PAYLOAD"
  end

  test "pass thread control is parsed from the response" do
    {:ok, file} = File.read("#{__DIR__}/fixtures/pass_thread_control.json")
    res = FacebookMessenger.Response.parse(file)

    %{type: "pass_thread_control", pass_thread_control: pass_thread_control} =
      res |> FacebookMessenger.Response.get_messaging()

    assert pass_thread_control.new_owner_app_id == "123456789"
    assert pass_thread_control.metadata == "METADATA"
  end

  test "request thread control is parsed from the response" do
    {:ok, file} = File.read("#{__DIR__}/fixtures/request_thread_control.json")
    res = FacebookMessenger.Response.parse(file)

    %{type: "request_thread_control", request_thread_control: request_thread_control} =
      res |> FacebookMessenger.Response.get_messaging()

    assert request_thread_control.requested_owner_app_id == "123456789"
    assert request_thread_control.metadata == "METADATA"
  end

  test "take thread control is parsed from the response" do
    {:ok, file} = File.read("#{__DIR__}/fixtures/take_thread_control.json")
    res = FacebookMessenger.Response.parse(file)

    %{type: "take_thread_control", take_thread_control: take_thread_control} =
      res |> FacebookMessenger.Response.get_messaging()

    assert take_thread_control.previous_owner_app_id == "123456789"
    assert take_thread_control.metadata == "METADATA"
  end

  test "it gets the message sender id" do
    {:ok, file} = File.read("#{__DIR__}/fixtures/messenger_response.json")
    res = FacebookMessenger.Response.parse(file)
    res = FacebookMessenger.Response.message_senders(res)
    assert res == ["USER_ID"]
  end
end
