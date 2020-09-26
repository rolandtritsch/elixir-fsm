defmodule FsmWeb.JobController do
  use FsmWeb, :controller

  def create(conn, _params) do
     {:ok, id} = PersistentJob.create() 
    
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(201, id)
  end

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
