defmodule FacebookMessenger.Callback do
  @moduledoc """
  This module defines the methods required for a module to become a callback handler for facebook
  messenger module
  """

  @doc """
  function called when a message is received from facebook
  """
  @callback message_received(FacebookMessenger.Response) :: any

  @doc """
  called when a challange has been received from facebook and the challange succeeeded
  """
  @callback challange_successfull(any) :: any

  @doc """
  called when a challange has been received from facebook and the challange failed
  """
  @callback challange_failed(any) :: any

end
