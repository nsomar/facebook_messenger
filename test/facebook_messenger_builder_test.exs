defmodule FacebookMessenger.BuilderTest do
  use ExUnit.Case

  import FacebookMessenger.Builder

  @id 1041671182605902

  setup_all do
    Agent.start_link(fn -> [] end, name: :options)
    :ok
  end

  test "sends correct button_template message" do
    body @id, :button_template, "test" do
      fields %{
        buttons: [
          %{
            type: "web_url",
            title: "Classic",
            url: "https://facebook.com"}
        ]
      }
    end

    assert_receive %{
      body: "{\"recipient\":{\"id\":1041671182605902},\"message\":{\"attachment\":{\"type\":\"template\",\"payload\":{\"text\":\"test\",\"template_type\":\"button\",\"buttons\":[{\"url\":\"https://facebook.com\",\"type\":\"web_url\",\"title\":\"Classic\"}]}}}}", url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"
    }
  end

  test "sends correct generic_template message" do
    body @id, :generic_template do
      fields %{
        elements: [
          %{
            title: "Classic"
          },
          %{
            title: "Classic 2",
            subtitle: "Subtitle for classic 2"
          }
        ]
      }
    end

    assert_received %{
      body: "{\"recipient\":{\"id\":1041671182605902},\"message\":{\"attachment\":{\"type\":\"template\",\"payload\":{\"template_type\":\"generic\",\"elements\":[{\"title\":\"Classic\"},{\"title\":\"Classic 2\",\"subtitle\":\"Subtitle for classic 2\"}]}}}}", url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"
    }
  end

  test "sends correct list_template message" do
    body @id, :list_template do
      fields %{
        top_element_style: "compact",
        elements: [
          %{
            title: "Classic shirt",
            subtitle: "First subtitle"
          },
          %{
            title: "Classic shirt 2",
            subtitle: "Second subtitle"
          }
        ]
      }
    end

    assert_received %{
      body: "{\"recipient\":{\"id\":1041671182605902},\"message\":{\"attachment\":{\"type\":\"template\",\"payload\":{\"top_element_style\":\"compact\",\"elements\":[{\"title\":\"Classic shirt\",\"subtitle\":\"First subtitle\"},{\"title\":\"Classic shirt 2\",\"subtitle\":\"Second subtitle\"}]}}}}", url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"
    }
  end

  test "sends correct quick_replies message" do
    body @id, :quick_replies, "test" do
      fields %{
        quick_replies: [
          %{
            content_type: "location"
          },
          %{
            content_type: "text",
            title: "Red"
          }
        ]
      }
    end

    assert_received %{
      body: "{\"recipient\":{\"id\":1041671182605902},\"message\":{\"text\":\"test\",\"quick_replies\":[{\"content_type\":\"location\"},{\"title\":\"Red\",\"content_type\":\"text\"}]}}", url: "https://graph.facebook.com/v2.6/me/messages?access_token=PAGE_TOKEN"
    }
  end
end
