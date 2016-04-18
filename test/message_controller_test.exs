
defmodule TestController do
  use FacebookMessenger.Phoenix.Controller

  def message_received(msg) do
    text = FacebookMessenger.Response.message_texts(msg) |> hd
    sender = FacebookMessenger.Response.message_senders(msg) |> hd
    FacebookMessenger.Sender.send(sender, text)
  end
end

defmodule FacebookMessenger.Controller.Test do
  use Test.ConnCase

  test "it returns the passed challenge if token matches" do
    conn = Map.put(conn(), :request_path, "/webhook/api")
    TestController.challenge(conn, %{"hub.mode" => "subscribe",
                "hub.verify_token" => "123123",
                "hub.challenge" => "1234567"})
    assert_receive {"/webhook/api", 200, "1234567"}
  end

  test "it returns error if webhook token does not match" do
    conn = Map.put(conn(), :request_path, "/webhook/api")
    TestController.challenge(conn, %{"hub.mode" => "subscribe",
                "hub.verify_token" => "1",
                "hub.challenge" => "1234567"})
    assert_receive {"/webhook/api", 500, ""}
  end

  test "it gets the callback successful event" do
    defmodule TestController2 do
      use FacebookMessenger.Phoenix.Controller

      def challenge_successfull(params) do
        send(self, 1)
      end
    end

    conn = Map.put(conn(), :request_path, "/webhook/api")
    TestController2.challenge(conn, %{"hub.mode" => "subscribe",
                "hub.verify_token" => "123123",
                "hub.challenge" => "1234567"})
    assert_receive 1
  end

   test "it gets the callback failed event" do
    defmodule TestController2 do
      use FacebookMessenger.Phoenix.Controller

      def challenge_failed(params) do
        send(self, 2)
      end
    end

    conn = Map.put(conn(), :request_path, "/webhook/api")
    TestController2.challenge(conn, %{"hub.mode" => "subscribe",
                "hub.verify_token" => "222",
                "hub.challenge" => "1234567"})
    assert_receive 2
  end

  test "it returns error if webhook is not valid" do
    conn = Map.put(conn(), :request_path, "/webhook/api")
    TestController.challenge(conn, 1)
    assert_receive {"/webhook/api", 500, ""}
  end

  test "it receives a message" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")
    {:ok, json} = file |> Poison.decode

    conn = Map.put(conn(), :request_path, "/webhook/message")
    TestController.webhook(conn, json)
    assert_receive %{body: "{\"recipient\":{\"id\":\"USER_ID\"},\"message\":{\"text\":\"hello\"}}", url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"}
       {"/webhook/message", ""}
  end

  test "it handles bad messages" do
    conn = Map.put(conn(), :request_path, "/webhook/message")
    TestController.webhook(conn, 1)
    assert_receive {"/webhook/message", 500, ""}
  end
end
