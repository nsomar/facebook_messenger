# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

case Mix.env do
  :test ->
    config :facebook_messenger,
      request_manager: FacebookMessenger.RequestManager.Mock,
      facebook_page_token: "PAGE_TOKEN",
      challange_verification_token: "123123"

    config :logger,
      level: :info

    config :facebook_messenger, Test.Endpoint,
      secret_key_base: "YaOVZRbaLGtZVFRTkXUONQgHLM2aJpgR+l5dd5c/GvaDIMNCDOq3EbnpxUI/fuoj"

  :dev ->
    config :facebook_messenger,
      request_manager: FacebookMessenger.RequestManager,
      challange_verification_token: "123123",
      facebook_page_token: "PAGE_TOKEN"

  _ -> true
end
