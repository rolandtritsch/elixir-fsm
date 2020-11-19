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

    defmodule IdResponse do
      OpenApiSpex.schema(%{
            description: "Return an id.",
            type: :object,
            properties: %{
              id: %OpenApiSpex.Schema{type: :string, description: "Id", format: :uuid}
            },
            required: [:id],
            example: %{
              "id" => "6a2f41a3-c54c-fce8-32d2-0324e1c32e22"
            }
      })
    end

    defmodule StateResponse do
      OpenApiSpex.schema(%{
            description: "Return a state.",
            type: :object,
            properties: %{
              state: %OpenApiSpex.Schema{type: :string, description: "State", pattern: ~r/(started)|(initialized)|(scheduled)|(running)|(processing)|(failed)/}
            },
            required: [:state],
            example: %{
              "state" => "started"
            }
      })
    end
  end
  
  @doc """
  /create 

  Create a job. Return the job id.
  """
  @doc responses: [
    created: {"Created", "text/plain", Schema.IdResponse}
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
    ok: {"Current state", "text/plain", Schema.IdResponse},
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

  @doc """
  /update/:id&transition=:transition

  Transition the given job to the next state (by applying the given transition).
  """
  @doc parameters: [
    path: [in: :path, type: :string, required: :true, description: "Id of the job"],
    transition: [in: :query, type: :string, required: :true, description: "Transition to apply"]
  ]
  @doc responses: [
    ok: {"New state", "text/plain", Schema.StateResponse},
    bad_request: {"Error", "text/plain", Schema.ErrorResponse}
  ]
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

  @doc """
  /delete/:id

  Delete the given job.
  """
  @doc parameters: [
    path: [in: :path, type: :string, required: :true, description: "Id of the job"]
  ]
  @doc responses: [
    ok: {"Id", "text/plain", Schema.IdResponse},
    bad_request: {"Error", "text/plain", Schema.ErrorResponse}
  ]
  def delete(conn, %{"id" => id}) do
    case PersistentJob.delete(id) do
      {:ok, id} -> 
        conn
        |> put_resp_content_type("text/plain")
        |> send_resp(:ok, id)
        
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
