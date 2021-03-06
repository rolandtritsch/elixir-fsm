defmodule FsmWeb.JobController do
  @moduledoc """
  All endpoints to manage jobs.
  """
  @moduledoc tags: ["jobs"]
  
  use FsmWeb, :controller
  use OpenApiSpex.Controller

  # plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

  defmodule Schema do
    require OpenApiSpex

    defmodule Error do
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

    defmodule Id do
      OpenApiSpex.schema(%{
            description: "An id.",
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

    defmodule State do
      OpenApiSpex.schema(%{
            description: "A state.",
            type: :object,
            properties: %{
              state: %OpenApiSpex.Schema{
                type: :string,
                description: "State",
                pattern: ~r/(started)|(initialized)|(scheduled)|(running)|(processing)|(failed)/
              }
            },
            required: [:state],
            example: %{
              "state" => "started"
            }
      })
    end

    defmodule Transition do
      OpenApiSpex.schema(%{
            description: "A tranisition.",
            type: :object,
            properties: %{
              state: %OpenApiSpex.Schema{
                type: :string,
                description: "Transition",
                pattern: ~r/(start)|(schedule)|(run)|(process)|(success)|(failure)|(done)/
              }
            },
            required: [:transition],
            example: %{
              "transition" => "run"
            }
      })
    end
  end
  
  @doc """
  /create 

  Create a job. Return the job id.
  """
  @doc responses: [
    created: {"Created", "text/plain", Schema.Id}
  ]
  def create(conn, _params) do
     {:ok, id} = PersistentJob.create() 
    
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(:created, id)
  end

  @doc """
  /retrieve/{id}

  Retrieve the current status of the given job.
  """
  @doc parameters: [
    id: [in: :path, schema: Schema.Id]
  ]
  @doc responses: [
    ok: {"Current state", "text/plain", Schema.Id},
    bad_request: {"Error", "text/plain", Schema.Error}
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
    id: [in: :path, schema: Schema.Id],
    transition: [in: :query, schema: Schema.Transition]
  ]
  @doc responses: [
    ok: {"New state", "text/plain", Schema.State},
    bad_request: {"Error", "text/plain", Schema.Error}
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
    id: [in: :path, schema: Schema.Id]
  ]
  @doc responses: [
    ok: {"Id", "text/plain", Schema.Id},
    bad_request: {"Error", "text/plain", Schema.Error}
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
