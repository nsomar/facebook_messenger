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
  called when a challenge has been received from facebook and the challenge succeeeded
  """
  @callback challenge_successfull(any) :: any

  @doc """
  called when a challenge has been received from facebook and the challenge failed
  """
  @callback challenge_failed(any) :: any

end
