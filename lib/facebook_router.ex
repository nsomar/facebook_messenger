defmodule FacebookMessenger.Router do
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  defmacro facebook_routes(controller) do
    quote do
      pipeline :messenger do
        plug :accepts, ["json"]
      end

      scope "/" do
        pipe_through :messenger
        get "/api/webhook",   unquote(controller), :challange
        post "/api/webhook",  unquote(controller), :webhook
      end
    end
  end
end
