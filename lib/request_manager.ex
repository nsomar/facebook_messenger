defmodule FacebookMessenger.RequestManager do
  @moduledoc """
  module respinsible to post a request to facebook
  """
  def post(url: url, body: body) do
    HTTPotion.post url,
    body: body, headers: ["Content-Type": "application/json"]
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

  def page_token() do
    Application.get_env(:facebook_messenger, :facebook_page_token)
  end
end
