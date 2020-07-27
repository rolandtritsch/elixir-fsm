defmodule Job do
  @behaviour :gen_statem

  def start_link do
    id = Ecto.UUID.generate() |> String.to_atom()
    {:ok, _pid} = :gen_statem.start_link({:local, id}, __MODULE__, :ok, [])
    {:ok, id}
  end

  @impl :gen_statem
  def init(_), do: {:ok, :created, nil}

  @impl :gen_statem
  def callback_mode, do: :handle_event_function

  @impl :gen_statem
  def handle_event({:call, from}, :start, :created, data) do
    {:next_state, :initialized, data, [{:reply, from, {:ok, :initialized}}]}
  end

  def handle_event({:call, from}, :schedule, :created, data) do
    {:next_state, :scheduled, data, [{:reply, from, {:ok, :scheduled}}]}
  end

  def handle_event({:call, from}, :start, :scheduled, data) do
    {:next_state, :initialized, data, [{:reply, from, {:ok, :initialized}}]}
  end

  def handle_event({:call, from}, :run, :initialized, data) do
    {:next_state, :running, data, [{:reply, from, {:ok, :running}}]}
  end

  def handle_event({:call, from}, :done, :running, data) do
    {:next_state, :exit, data, [{:reply, from, {:ok, :exit}}]}
  end

  def handle_event({:call, from}, :process, :running, data) do
    {:next_state, :processing, data, [{:reply, from, {:ok, :processing}}]}
  end

  def handle_event({:call, from}, :success, :processing, data) do
    {:next_state, :running, data, [{:reply, from, {:ok, :running}}]}
  end

  def handle_event({:call, from}, :failure, :processing, data) do
    {:next_state, :failed, data, [{:reply, from, {:ok, :failed}}]}
  end

  def handle_event({:call, from}, :done, :failed, data) do
    {:next_state, :exit, data, [{:reply, from, {:ok, :exit}}]}
  end

  def handle_event({:call, from}, :processing, :done, data) do
    {:next_state, :exit, data, [{:reply, from, {:ok, :exit}}]}
  end

  def handle_event({:call, from}, :retrieve, state, data) do
    {:next_state, state, data, [{:reply, from, {:ok, state}}]}
  end

  def handle_event({:call, from}, _event, _content, data) do
    {:keep_state, data, [{:reply, from, {:error, :invalid_transition}}]}
  end
end
