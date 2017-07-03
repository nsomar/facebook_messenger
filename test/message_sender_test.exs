
defmodule TestBotOne.MessageSenderTest do
  use ExUnit.Case

  test "creates a correct url" do
    assert FacebookMessenger.Sender.url == "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"
  end

  test "sends sender_action" do
    FacebookMessenger.Sender.sender_action(1055439761215256, :typing_on)
    assert_received %{body: "{\"sender_action\":\"typing_on\",\"recipient\":{\"id\":1055439761215256}}", url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"}
  end

  test "sends correct text message" do
    FacebookMessenger.Sender.send(1055439761215256, "Hello")
    assert_received %{body: "{\"recipient\":{\"id\":1055439761215256},\"message\":{\"text\":\"Hello\"}}", url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"}
  end

  test "sends correct image message" do
    FacebookMessenger.Sender.send_image(1055439761215256, "sample.com/some_image.png")
    assert_received %{body: "{\"recipient\":{\"id\":1055439761215256},\"message\":{\"attachment\":{\"type\":\"image\",\"payload\":{\"url\":\"sample.com/some_image.png\"}}}}", url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"}
  end

  test "sends correct template" do
    template = %{
      "template_type" => "button",
      "text" => "What do you want to do next?",
      "buttons" => [%{
                       "type" => "web_url",
                       "url" => "https://petersapparel.parseapp.com",
                       "title" => "Show Website"
                    }
                   ]}
    FacebookMessenger.Sender.send_template(1055439761215256, template)

    body = "{\"recipient\":{\"id\":1055439761215256},\"message\":{\"attachment\":{\"type\":\"template\",\"payload\":#{Poison.encode!(template)}}}"
    %{body: body} = assert_received %{url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"}

    payload = Poison.decode!(body)["message"]["attachment"]["payload"]
    assert payload == template
  end

end
