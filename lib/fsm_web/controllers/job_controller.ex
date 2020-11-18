defmodule FsmWeb.JobController do
  @moduledoc """
  All endpoints to manage jobs.
  """
  
  use FsmWeb, :controller
  use OpenApiSpex.Controller

  defmodule Schema do
    require OpenApiSpex

    defmodule ErrorResponse do
      OpenApiSpex.schema(%{
            description: "Something went wrong. Return the reason.",
            type: :object,
            properties: %{
              error: %OpenApiSpex.Schema{type: :string, description: "Error"}
            },
            required: [:error],
            example: %{
              "error" => "invalid id"
            }
      })
    end

    defmodule CreateResponse do
      OpenApiSpex.schema(%{
            description: "Return id of the created job.",
            type: :object,
            properties: %{
              created: %OpenApiSpex.Schema{type: :string, description: "Created", format: :uuid}
            },
            required: [:created],
            example: %{
              "created" => "6a2f41a3-c54c-fce8-32d2-0324e1c32e22"
            }
      })
    end

    defmodule RetrieveResponse do
      OpenApiSpex.schema(%{
            description: "Return the current status of the given job.",
            type: :object,
            properties: %{
              status: %OpenApiSpex.Schema{type: :string, description: "Status", pattern: ~r/(started)|(initialized)|(scheduled)|(running)|(processing)|(failed)/}
            },
            required: [:status],
            example: %{
              "status" => "started"
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
    |> send_resp(:created, id)
  end

  @doc """
  /retrieve/:id

  Retrieve the current status of the given job.
  """
  @doc parameters: [
    path: [in: :path, type: :string, required: :true, description: "Id of the job"]
  ]
  @doc responses: [
    ok: {"Status", "text/plain", Schema.RetrieveResponse},
    bad_request: {"Error", "text/plain", Schema.ErrorResponse}
  ]
  def retrieve(conn, %{"id" => id}) do
    case PersistentJob.retrieve(id) do
      {:ok, state} -> 
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(:ok, state)
        
      {:error, :invalid_id} ->
         conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(:bad_request, "invalid id")
        
      error ->
         conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(:bad_request, inspect(error))
    end
  end

  @doc false
  def update(conn, %{"id" => id, "transition" => transition}) do
    case PersistentJob.update(id, transition) do
      {:ok, state} -> 
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(:ok, state)
        
      {:error, :invalid_id} ->
         conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(:bad_request, "invalid id")
        
      {:error, :invalid_transition} ->
         conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(:bad_request, "invalid transition")
        
      error ->
         conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(:bad_request, inspect(error))
    end
  end

  @doc false
  def delete(conn, %{"id" => id}) do
    case PersistentJob.delete(id) do
      {:ok, _id} -> 
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(:ok, "deleted")
        
      {:error, :invalid_id} ->
         conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(:bad_request, "invalid id")
        
      error ->
         conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(:bad_request, inspect(error))
    end
  end
end
