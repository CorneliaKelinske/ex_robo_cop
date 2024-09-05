defmodule ExRoboCop.SecretAnswer do
  @moduledoc """
  GenServer storing the text of the generated Captcha along with
  a UIID assigned to each individual user so that the user's captcha
  answer can be verified
  """
  use GenServer

  # Client

  @spec start_link(map) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(%{}) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  @spec check_in(String.t()) :: String.t()
  def check_in(captcha_text) do
    GenServer.call(__MODULE__, {:check_in, captcha_text})
  end

  @spec check_out({String.t(), String.t()}) :: :error | {:error, :wrong_captcha} | :ok
  def check_out({text, form_id}) do
    GenServer.call(__MODULE__, {:check_out, text, form_id})
  end

  @spec check_out(String.t()) :: {:error, :form_id_not_found} | {:ok, String.t()}
  def check_out(form_id) do
    GenServer.call(__MODULE__, {:check_out, form_id})
  end

  # Server

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:check_in, captcha_text}, _from, state) do
    id = UUID.uuid4()
    state = Map.put(state, id, captcha_text)
    {:reply, id, state}
  end

  @impl GenServer
  def handle_call({:check_out, form_id}, _from, state) do
    case Map.fetch(state, form_id) do
      {:ok, answer} -> {:reply, {:ok, answer}, state}
      _ -> {:reply, {:error, :form_id_not_found}, state}
    end
  end

  def handle_call({:check_out, text, form_id}, _from, state) do
    new_state = Map.delete(state, form_id)

    case Map.fetch(state, form_id) do
      {:ok, ^text} -> {:reply, :ok, new_state}
      {:ok, _} -> {:reply, {:error, :wrong_captcha}, new_state}
      _ -> {:reply, :error, new_state}
    end
  end
end
