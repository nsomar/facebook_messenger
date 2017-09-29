defmodule FacebookMessenger.RequestManager do

  @timeout 30000
  @moduledoc """
  module respinsible to post a request to facebook
  """
  def post(url: url, body: body) do
    HTTPotion.post url,
      body: body, headers: ["Content-Type": "application/json"],
      timeout: @timeout
  end

  def get(url: url) do
    HTTPotion.get url,
      timeout: @timeout
  end

  def delete(url: url, body: body) do
    HTTPotion.delete url,
      body: body, headers: ["Content-Type": "application/json"],
      timeout: @timeout
  end

  def page_token() do
    Application.get_env(:facebook_messenger, :facebook_page_token)
  end

end

defmodule FacebookMessenger.RequestManager.Mock do
  @moduledoc """
  moc respinsible to post a request to facebook
  """

  def post(url: url, body: body) do
    send(self, %{url: url, body: body})
  end

  def get(url: url, body: body) do
    send(self, %{url: url})
  end

  def delete(url: url) do
    send(self, %{url: url})
  end

  def page_token() do
    Application.get_env(:facebook_messenger, :facebook_page_token)
  end
end
