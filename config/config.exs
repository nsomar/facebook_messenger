# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :logger,
  level: :info

case Mix.env do
  :test ->
    config :facebook_messenger,
      request_manager: FacebookMessenger.RequestManager.Mock,
      facebook_page_token: "PAGE_TOKEN",
      challenge_verification_token: "123123",
      responder: FacebookMessenger.Responder.Mock

  :dev ->
    config :facebook_messenger,
      request_manager: FacebookMessenger.RequestManager,
      facebook_page_token: "PAGE_TOKEN",
      challenge_verification_token: "123123",
      responder: FacebookMessenger.Responder

  _ -> true
end
