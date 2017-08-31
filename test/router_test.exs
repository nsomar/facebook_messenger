defmodule MockRouter do
  use Plug.Router

  plug :match
  plug :dispatch

  forward "/messenger/webhook",
    to: FacebookMessenger.Router,
    challange_succeeded: &MockRouter.success/0,
    challange_failed: &MockRouter.failure/0,
    message_received: &MockRouter.message/1

  match _, do: conn

  def success, do: send(self(), 1)
  def failure, do: send(self(), 2)
  def message(msg) do
    text = FacebookMessenger.Response.message_texts(msg)
    sender = FacebookMessenger.Response.message_senders(msg)
    FacebookMessenger.Sender.send(sender, text)
    send(self(), 3)
  end

end

defmodule FacebookMessenger.Router.Test do
  use ExUnit.Case
  use Plug.Test

  test "challange: returns 500 for wrong paths" do
    conn = conn(:get, "/wrong")
    router = FacebookMessenger.Router.init([])
    {status, _, _body} = FacebookMessenger.Router.call(conn, router) |> sent_resp
    assert status == 500

    conn = conn(:get, "/messenger/webhook")
    router = FacebookMessenger.Router.init([])
    {status, _, _body} = FacebookMessenger.Router.call(conn, router) |> sent_resp
    assert status == 500
  end

  test "challange: returns 200 for correct paths" do
    conn = conn(:get, "/messenger/webhook?hub.mode=subscribe&hub.challenge=914942744&hub.verify_token=VERIFY_TOKEN")
    router = FacebookMessenger.Router.init([])
    {status, _, body} = FacebookMessenger.Router.call(conn, router) |> sent_resp
    assert status == 200
    assert body == "914942744"
  end

  test "challange: returns 500 if token is incorrect" do
    conn = conn(:get, "/messenger/webhook?hub.mode=subscribe&hub.challenge=914942744&hub.verify_token=VERIFY_TOKEN2")
    router = FacebookMessenger.Router.init([])
    {status, _, body} = FacebookMessenger.Router.call(conn, router) |> sent_resp
    assert status == 500
    assert body == ""
  end

  test "message: returns 200 for correct message" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")
    conn = conn(:post, "/messenger/webhook", file)

    router = FacebookMessenger.Router.init([])
    {status, _, body} = FacebookMessenger.Router.call(conn, router) |> sent_resp

    assert status == 200
    assert body == ""
  end

  test "message: returns 500 for bad message" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")
    conn = conn(:post, "/messenger/webhook2", file)

    router = FacebookMessenger.Router.init([])
    {status, _, body} = FacebookMessenger.Router.call(conn, router) |> sent_resp

    assert status == 500
    assert body == ""
  end

  test "message: returns 500 for bad payload" do
    conn = conn(:post, "/messenger/webhook2", "1")

    router = FacebookMessenger.Router.init([])
    {status, _, body} = FacebookMessenger.Router.call(conn, router) |> sent_resp

    assert status == 500
    assert body == ""
  end

  test "message: it sends a message if correct" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")
    conn = conn(:post, "/messenger/webhook", file)

    router = MockRouter.init([])
    MockRouter.call(conn, router) |> sent_resp

    assert_received %{body: "{\"recipient\":{\"id\":\"USER_ID\"},\"message\":{\"text\":\"hello\"}}", url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"}
  end

  test "challange: 200 calls the success function" do

    conn = conn(:get, "/messenger/webhook?hub.mode=subscribe&hub.challenge=914942744&hub.verify_token=VERIFY_TOKEN")
    router = MockRouter.init([])
    MockRouter.call(conn, router)
    assert_received 1
  end

  test "challange: 500 calls the failure function" do
    conn = conn(:get, "/messenger/webhook?hub.mode=subscribe&hub.challenge=914942744&hub.verify_token=VERIFY_TOKEN2")
    router = MockRouter.init([])
    MockRouter.call(conn, router)
    assert_received 2
  end

  test "message: 200 calls the message function" do
    {:ok, file} = File.read("#{System.cwd}/test/fixtures/messenger_response.json")
    conn = conn(:post, "/messenger/webhook", file)

    router = MockRouter.init([])
    MockRouter.call(conn, router) |> sent_resp
    assert_received 3
  end
end
