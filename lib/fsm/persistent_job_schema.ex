defmodule PersistentJob.Schema do
  use Ecto.FSM.Schema

  @primary_key {:id, :string, autogenerate: false}

  schema "jobs" do
    status(PersistentJob)
  end
  
  def new() do
    %PersistentJob.Schema{id: Ecto.UUID.generate(), status: :created}
  end  
end
