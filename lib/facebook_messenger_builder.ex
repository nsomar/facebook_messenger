defmodule FacebookMessenger.Builder do
  @moduledoc """
  Build the body of a response to Messenger.
  """

  alias FacebookMessenger.Sender

  # TODO: Open Graph - Receipt and all Airline templates.

  @doc false
  def start_link do
    Agent.start(fn -> [] end, name: :options)
  end

  @doc """
  Sends a message to the recipient with options for
  templates, buttons and quick-replies.
  """
  @spec body(integer, atom, String.t) :: HTTPotion.Response.t
  defmacro body(id, msg_type \\ :button_template, text \\ nil, [do: group_body]) do
    quote do
      # Do all operations so the state is saved already on the Agent
      unquote(group_body)

      # Changes payload body based on the msg_type
      build_and_send(unquote(id), unquote(msg_type), unquote(text))

      # Cleans state after each operation
      Agent.update(:options, fn _state -> [] end)
    end
  end

  @doc false
  def fields(body) when is_map(body),
    do: update_agent_list(:options, body)

  # Updates agent and adds value to tail of list
  @doc false
  defp update_agent_list(agent, body),
    do: Agent.update(agent, fn state -> List.insert_at(state, -1, body) end)

  # Builds the payload based on arg
  @doc false
  def build_and_send(id, :button_template, text) do
    buttons_list =
      :options
      |> Agent.get(&(&1))
      |> Enum.at(0)

    payload = %{
      recipient: %{id: id},
      message: %{
        attachment: %{
          type: "template",
          payload: %{
            template_type: "button",
            text: text,
            buttons: Map.get(buttons_list, :buttons)
          }
        }
      }
    }

    payload = Sender.to_json(payload)
    Sender.manager.post(url: Sender.url(), body: payload)
  end

  def build_and_send(id, :generic_template, _text) do
    generic_list =
      :options
      |> Agent.get(&(&1))
      |> Enum.at(0)

    payload = %{
      recipient: %{id: id},
      message: %{
        attachment: %{
          type: "template",
          payload: %{
            template_type: "generic",
            elements: Map.get(generic_list, :elements)
          }
        }
      }
    }

    payload = Sender.to_json(payload)
    Sender.manager.post(url: Sender.url(), body: payload)
  end

  def build_and_send(id, :list_template, _text) do
    opt_map =
      :options
      |> Agent.get(&(&1))
      |> Enum.at(0)

    payload = %{
      recipient: %{id: id},
      message: %{
        attachment: %{
          type: "template",
          payload: Map.get(opt_map, :payload)
        }
      }
    }
    |> Sender.to_json

    Sender.manager.post(url: Sender.url(), body: payload)
  end

  def build_and_send(id, :quick_replies, text) do
    quick_replies_list =
      :options
      |> Agent.get(&(&1))
      |> Enum.at(0)

    payload =
      %{
        recipient: %{id: id},
        message: %{
          text: text,
          quick_replies: Map.get(quick_replies_list, :quick_replies)
        }
      }
      |> Sender.to_json

    Sender.manager.post(url: Sender.url(), body: payload)
  end
end
