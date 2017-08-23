defmodule FacebookMessenger.Builder do
  @moduledoc false

  # Goal: Make a macro that accepts a body and print
  # more maps based on the info given
  def start_link do
    Agent.start(fn -> [] end, name: :buttons)
    Agent.start(fn -> [] end, name: :elements)
  end

  defmacro body(id, msg_type \\ :button_template, text \\ nil, [do: body]) do
    quote do
      # Do all operations so the state is saved already on the Agent
      unquote(body)

      # Changes payload body basedon the msg_type
      payload_body = %{
        recipient: %{id: unquote(id)},
        message: build_payload(unquote(msg_type), unquote(text))
      }

      # Cleans state for each operation
      Agent.update(:buttons, fn _state -> [] end)
      Agent.update(:elements, fn _state -> [] end)

      payload_body
    end
  end

  def fields(body) when is_map(body),
    do: update_agent_list(:buttons, body)

  def elements_field(body) when is_map(body),
    do: update_agent_list(:elements, body)

  defp update_agent_list(agent, body),
    do: Agent.update(agent, fn state -> List.insert_at(state, -1, body) end)

  # builds list for "elements" key on payload
  def elements_key_payload do
    elements = Agent.get(:elements, &(&1))
    buttons = Agent.get(:buttons, &(&1))

    buttons_map = %{buttons: buttons}

    Enum.map(elements, &Map.merge(&1, buttons_map))
  end

  # Builds the payload based on arg
  def build_payload(:button_template, text) do
    %{
      attachment: %{
        type: "template",
        payload: %{
          template_type: "button",
          text: text,
          buttons: Agent.get(:buttons, &(&1))
        }
      }
    }
  end

  def build_payload(:generic_template, text) do
    %{
      attachment: %{
        type: "template",
        payload: %{
          template_type: "generic",
          elements: elements_key_payload()
        }
      }
    }
  end
end
