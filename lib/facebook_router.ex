defmodule FacebookMessenger.Phoenix.Router do
  @moduledoc """
  Router module, this module will be responsible to defines the default routes needed for facebook
  bot communication.

  The routes are
  - get `/api/webhook` for challenges
  - post `/api/webhook` for webhook communication
  """
  defmacro __using__(_) do
    quote do
      import unquote(__MODULE__)
    end
  end

  @doc """
  function responsible for defining the routes used for facebook messenger bot communication

  The routes are:
  - get `/api/webhook` for challenges
  - post `/api/webhook` for webhook communication

  It takes a controller that `use FacebookMessenger.Controller`

  Example:
  in test_controller.ex
  ```
  defmodule TestController do
    use FacebookMessenger.Controller

    def message_received(msg) do
      ....
    end
  end
  ```

  Then in routes.ex
  ```
  defmodule YourApp.Router do
    use YourApp.Web, :router

    # Add these two lines
    use FacebookMessenger.Router
    facebook_routes TestController
  end
  ```

  Parameters:

  - `path` the webhook path you want to use to receive webhook events
  - `controller` the controller that use `FacebookMessenger.Controller`
  """
  @spec facebook_routes(String.t, module) :: any
  defmacro facebook_routes(path, controller) do
    quote do
      pipeline :messenger do
        plug :accepts, ["json"]
      end

      scope "/" do
        pipe_through :messenger
        get unquote(path),   unquote(controller), :challenge
        post unquote(path),  unquote(controller), :webhook
      end
    end
  end
end
