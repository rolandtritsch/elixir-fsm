defmodule PersistentJob do
  use Ecto.Schema
  alias Fsm.Repo

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "jobs" do
    field :state, :string, default: "created"
  end

  use Fsmx.Struct, transitions: %{
    "created" => ["initialized", "scheduled"],
    "scheduled" => "initialized",
    "initialized" => "running",
    "running" => ["processing", "exited"],
    "processing" => ["running", "failed"],
    "failed" => "exited"
  }

  def create() do
    job = %PersistentJob{}
    {:ok, %{id: id}} = Repo.insert(job)
    {:ok, id}
  end

  def retrieve(id) do
    case PersistentJob |> Repo.get(id) do
      %{state: state} ->
        {:ok, state}

      _ ->
        {:error, :invalid_id}
    end
  end

  def update(id, state) do
    case PersistentJob |> Repo.get(id) do
      %PersistentJob{} = job ->
        case Fsmx.transition_changeset(job, state) |> Repo.update() do
          {:ok, _} ->
            {:ok, state}

          _ ->
            {:error, :invalid_transition}
        end
      _ ->
        {:error, :invalid_id}
    end
  end

  def delete(id) do
    case PersistentJob |> Repo.get(id) do
      %PersistentJob{} = job ->
        {:ok, _job} = Repo.delete(job)
        {:ok, id}

      _ ->
        {:error, :invalid_id}
    end
  end

  def target("schedule"), do: "scheduled"
  def target("start"), do: "initialized"
  def target("run"), do: "running"
  def target("process"), do: "processing"
  def target("success"), do: "running"
  def target("failure"), do: "failed"
  def target("done"), do: "exited"
  def target(_), do: "unknown"  
end
