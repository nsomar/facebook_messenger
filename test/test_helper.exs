defmodule Test.ConnCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ConnTest
      @endpoint Test.Endpoint
    end
  end

  setup tags do
    {:ok, conn: Phoenix.ConnTest.conn()}
  end
end

ExUnit.start()
