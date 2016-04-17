# ExFacebookMessenger
[![Build Status](https://travis-ci.org/oarrabi/EXFacebook-Messenger.svg?branch=master)](https://travis-ci.org/oarrabi/EXFacebook-Messenger)
[![Hex.pm](https://img.shields.io/hexpm/v/EXFacebook-Messenger.svg)](https://hex.pm/packages/EXFacebook-Messenger)
[![API Docs](https://img.shields.io/badge/api-docs-yellow.svg?style=flat)](http://hexdocs.pm/EXFacebook-Messenger/)
[![Coverage Status](https://coveralls.io/repos/github/oarrabi/EXFacebook-Messenger/badge.svg?branch=master)](https://coveralls.io/github/oarrabi/EXFacebook-Messenger?branch=master)
[![Inline docs](http://inch-ci.org/github/oarrabi/EXFacebook-Messenger.svg?branch=master)](http://inch-ci.org/github/oarrabi/EXFacebook-Messenger)

ExFacebookMessenger is a library that easy the creation of facebook messenger bots.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add facebook_messenger to your list of dependencies in `mix.exs`:

        def deps do
          [{:facebook_messenger, "~> 0.0.1"}]
        end

  2. Ensure facebook_messenger is started before your application:

        def application do
          [applications: [:facebook_messenger]]
        end

## Requirements
- a Phoenix App with phoenix `1.1` and up

## Usage
You need to have a working phoenix app to use ExFacebookMessenger.

To create an echo back bot, do the following:

Create a new controller `web/controller/test_controller.ex`

```
defmodule TestController do
  use FacebookMessenger.Controller

  def message_received(msg) do
    text = FacebookMessenger.Response.message_texts(msg) |> hd
    sender = FacebookMessenger.Response.message_senders(msg) |> hd
    FacebookMessenger.Sender.send(sender, text)
  end
end
```

Add the required routes in `web/router.ex`
```
defmodule YourApp.Router do
  use YourApp.Web, :router

  # Add these two lines
  use FacebookMessenger.Router
  facebook_routes "webhook", TestController
end
```
This defines a webhook endpoint at:
`http://your-app-url/webhook`

Go to your `config/config.exs` and add the required configurations
```
config :facebook_messenger,
      facebook_page_token: "Your facebook page token",
      challange_verification_token: "the challange verify token"
```

To get the `facebook_page_token` and `challange_verification_token` follow the instructions [here ](https://developers.facebook.com/docs/messenger-platform/quickstart)

For the webhook endpoint use `http://your-app-url/webhook`
