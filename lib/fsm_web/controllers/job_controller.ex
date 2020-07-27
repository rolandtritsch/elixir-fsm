defmodule FsmWeb.JobController do
  use FsmWeb, :controller

  def create(conn, _params) do
    {:ok, id} = Job.start_link() 
    
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(201, Atom.to_string(id))
  end

  def retrieve(conn, %{"id" => id}) do
    try do
      String.to_existing_atom(id)
    rescue
      ArgumentError ->
        conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(400, "invalid id")
    else
      id ->
        case :gen_statem.call(id, :retrieve) do
          {:ok, state} -> 
            conn
            |> put_resp_content_type("text/plain")
            |> send_resp(200, Atom.to_string(state))

          error -> 
            conn |> send_resp(400, "#{inspect(error)}")
        end
    end
  end

  def update(conn, %{"id" => id, "transition" => transition}) do
    try do
      {String.to_existing_atom(id), String.to_existing_atom(transition)}
    rescue
      ArgumentError ->
        conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(400, "invalid id")
    else
      {id, transition} ->
        case :gen_statem.call(id, transition) do
          {:ok, state} -> 
            conn
            |> put_resp_content_type("text/plain")
            |> send_resp(200, Atom.to_string(state))

          {:error, :invalid_transition} -> 
            conn 
            |> put_resp_content_type("text/plain")
            |> send_resp(400, "invalid transition")

          error -> 
            conn 
            |> put_resp_content_type("text/plain")
            |> send_resp(400, "#{inspect(error)}")

        end
    end
  end

  def delete(conn, %{"id" => id}) do
    try do
      String.to_existing_atom(id)
    rescue
      ArgumentError ->
        conn 
        |> put_resp_content_type("text/plain")
        |> send_resp(400, "invalid id")
    else
      id ->
        :ok = :gen_statem.stop(id)

      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(200, "deleted")
    end
  end
end
