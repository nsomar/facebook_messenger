defmodule FacebookMessenger.RequestManager do
  def post(url: url, body: body) do
    HTTPotion.post url,
    body: body, headers: ["Content-Type": "application/json"]
  end
end

defmodule FacebookMessenger.RequestManager.Mock do
  def post(url: url, body: body) do
    send(self, %{url: url, body: body})
  end
end
