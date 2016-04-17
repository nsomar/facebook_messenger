
defmodule TestController do
  use FacebookMessenger.Controller
  def verify_successful(conn) do
    10
  end

  def verify_failed(conn) do
    20
  end
end

Task.start(Test.Endpoint, :start_link, [])

defmodule FacebookMessenger.Controller.Test do
  use Test.ConnCase

  test "creates a correct url" do
    TestController.challange(conn(), %{"hub.mode" => "subscribe",
                "hub.verify_token" => "123123",
                "hub.challenge" => "10"})
    # :ets.lookup(Test.Endpoint, :http)
    # a = Test.Router.init conn()
    # conn = conn() |> Map.put(:path_info, "/api/webhook?hub.mode=subscribe&hub.challenge=914942744&hub.verify_token=123123")
    # Test.Router.call a, conn
    # conn = get conn(), "/api/webhook"
    # assert conn.status == 500
    # assert conn.resp_body == "{\"error\":{\"path\":\"/api/webhook\",\"params\":{}}}"
  end
end
