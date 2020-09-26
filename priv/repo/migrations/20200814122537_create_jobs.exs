defmodule Fsm.Repo.Migrations.CreateJobs do
  use Ecto.Migration

  def change do
    create table(:jobs, primary_key: false) do
      add :id, :string, primary_key: true
      add :status, :string
    end
  end
end
