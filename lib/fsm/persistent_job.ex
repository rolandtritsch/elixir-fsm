defmodule PersistentJob do  
  use Ecto.FSM
  alias Fsm.Repo

  def create() do
    job = PersistentJob.Schema.new()
    {:ok, %{id: id}} = Repo.insert(job)    
    {:ok, id}
  end

  def retrieve(id) do
    case PersistentJob.Schema |> Repo.get(id) do
      nil ->
        {:error, :invalid_id}

      job ->
        {:ok, job |> Ecto.FSM.Machine.State.state_name() |> Atom.to_string()}
    end
  end

  def update(id, transition) do
    transition = transition |> String.to_atom()

    case PersistentJob.Schema |> Repo.get(id) do
      nil ->
        {:error, :invalid_id}

      job ->
        case job |> Ecto.FSM.Machine.event({transition, nil}) do
          {:error, :illegal_action} ->
            {:error, :invalid_transition}
            
          {:ok, next_state} ->
            {:ok, job} = next_state |> Repo.update()
            {:ok, job |> Ecto.FSM.Machine.State.state_name() |> Atom.to_string()}
        end
    end
  end
  
  def delete(id) do
    case PersistentJob.Schema |> Repo.get(id) do
      nil ->
        {:error, :invalid_id}

      job ->
        {:ok, _job} = Repo.delete(job)
        {:ok, id}
    end
  end

  # ---
  
  @doc "New to Created"
  @to [:created]
  transition new({:create, _}, s) do
    {:next_state, :created, s}
  end  

  @doc "Created to Initialized"
  @to [:initialized]
  transition created({:start, _}, s) do
    {:next_state, :initialized, s}
  end  

  @doc "Created to Scheduled"
  @to [:scheduled]
  transition created({:schedule, _}, s) do
    {:next_state, :scheduled, s}
  end  

  @doc "Scheduled to Initialized"
  @to [:initialized]
  transition scheduled({:start, _}, s) do
    {:next_state, :initialized, s}
  end  

  @doc "Initialized to Running"
  @to [:running]
  transition initialized({:run, _}, s) do
    {:next_state, :running, s}
  end  

  @doc "Running to Processing"
  @to [:processing]
  transition running({:process, _}, s) do
    {:next_state, :processing, s}
  end  

  @doc "Running to Exited"
  @to [:exited]
  transition running({:done, _}, s) do
    {:next_state, :exited, s}
  end

  @doc "Processing to Running"
  @to [:running]
  transition processing({:success, _}, s) do
    {:next_state, :running, s}
  end  

  @doc "Processing to Failed"
  @to [:failed]
  transition processing({:failure, _}, s) do
    {:next_state, :failed, s}
  end  

  @doc "Failed to Exited"
  @to [:exited]
  transition failed({:done, _}, s) do
    {:next_state, :exited, s}
  end
end
