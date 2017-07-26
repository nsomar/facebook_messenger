
defmodule TestBotOne.MessageSenderTest do
  use ExUnit.Case

  test "creates a correct url" do
    assert FacebookMessenger.Sender.url == "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"
  end

  test "creates a correct image payload" do
    assert FacebookMessenger.Sender.image_payload(1055439761215256, "sample.com/some_image.png") ==
      %{
        recipient: %{id: 1055439761215256},
        message: %{
           attachment: %{type: "image", payload: %{url: "sample.com/some_image.png"}}
        }
       }
  end

  test "creates a correct text payload" do
    assert FacebookMessenger.Sender.text_payload(1055439761215256, "Hello") ==
    %{message: %{text: "Hello"}, recipient: %{id: 1055439761215256}}
  end

  test "converts hash to json"do
    assert FacebookMessenger.Sender.to_json(%{test_key: "test_value"}) ==
    "{\"test_key\":\"test_value\"}"
  end

  test "sends correct text message" do
    FacebookMessenger.Sender.send(1055439761215256, "Hello")
    assert_received %{body: "{\"recipient\":{\"id\":1055439761215256},\"message\":{\"text\":\"Hello\"}}", url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"}
  end

  test "sends correct image message" do
    FacebookMessenger.Sender.send_image(1055439761215256, "sample.com/some_image.png")
    assert_received %{body: "{\"recipient\":{\"id\":1055439761215256},\"message\":{\"attachment\":{\"type\":\"image\",\"payload\":{\"url\":\"sample.com/some_image.png\"}}}}", url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"}
  end

  test "sends correct text message with buttons" do
    buttons = [
      %FacebookMessenger.Request.Button{title: "t1", payload: "p1"},
      %FacebookMessenger.Request.Button{title: "t2", payload: "p2"}
    ]
    
    FacebookMessenger.Sender.send(1055439761215256, "Hello", buttons)
    assert_received  %{body: "{\"recipient\":{\"id\":1055439761215256},\"message\":{\"attachment\":{\"type\":\"template\",\"payload\":{\"text\":\"Hello\",\"template_type\":\"button\",\"buttons\":[{\"type\":\"postback\",\"title\":\"t1\",\"payload\":\"p1\"},{\"type\":\"postback\",\"title\":\"t2\",\"payload\":\"p2\"}]}}}}", url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"}
  end
end
