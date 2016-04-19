defmodule FacebookMessenger.Router.Test do
  use ExUnit.Case
  use Plug.Test

  test "challange: returns 500 for wrong paths" do
    conn = conn(:get, "/wrong")
    router = FacebookMessenger.Router.init([])
    {status, _, body} = FacebookMessenger.Router.call(conn, router) |> sent_resp
    assert status == 500

    conn = conn(:get, "/messenger/webhook")
    router = FacebookMessenger.Router.init([])
    {status, _, body} = FacebookMessenger.Router.call(conn, router) |> sent_resp
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

    router = FacebookMessenger.Router.init([])
    {status, _, body} = FacebookMessenger.Router.call(conn, router) |> sent_resp

    assert_received %{body: "{\"recipient\":{\"id\":\"USER_ID\"},\"message\":{\"text\":\"hello\"}}", url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"}
  end
end
