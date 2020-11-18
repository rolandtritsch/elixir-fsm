defmodule FsmWeb.JobController do
  @moduledoc """
  All endpoints to manage jobs.
  """
  
  use FsmWeb, :controller
  use OpenApiSpex.Controller

  defmodule Schema do
    require OpenApiSpex

    defmodule CreateResponse do
      OpenApiSpex.schema(%{
            description: "Created a/the job.",
            type: :object,
            properties: %{
              created: %OpenApiSpex.Schema{type: :string, description: "Created", pattern: ~r/[0-9a-fA-F]{8}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{4}\-[0-9a-fA-F]{12}/}
            },
            required: [:created],
            example: %{
              "created" => "6a2f41a3-c54c-fce8-32d2-0324e1c32e22"
            }
      })
    end
  end
  
  @doc """
  /create

  Create a job. Return the job id.
  """
  @doc responses: [
    created: {"Created", "text/plain", Schema.CreateResponse}
  ]
  def create(conn, _params) do
     {:ok, id} = PersistentJob.create() 
    
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(201, id)
  end

  @doc false
  def retrieve(conn, %{"id" => id}) do
    case PersistentJob.retrieve(id) do
      {:ok, state} -> 
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, state)
        
      {:error, :invalid_id} ->
         conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(400, "invalid id")
        
      error ->
         conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(400, inspect(error))
    end
  end

  @doc false
  def update(conn, %{"id" => id, "transition" => transition}) do
    case PersistentJob.update(id, transition) do
      {:ok, state} -> 
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, state)
        
      {:error, :invalid_id} ->
         conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(400, "invalid id")
        
      {:error, :invalid_transition} ->
         conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(400, "invalid transition")
        
      error ->
         conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(400, inspect(error))
    end
  end

  @doc false
  def delete(conn, %{"id" => id}) do
    case PersistentJob.delete(id) do
      {:ok, _id} -> 
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(200, "deleted")
        
      {:error, :invalid_id} ->
         conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(400, "invalid id")
        
      error ->
         conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(400, inspect(error))
    end
  end
end
