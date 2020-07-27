defmodule FsmWeb.JobController do
  use FsmWeb, :controller

  def create(conn, _params) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(201, "#{Ecto.UUID.generate()}")
  end

  def retrieve(conn, %{"id" => id}) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "#{id}")
  end

  def update(conn, %{"id" => id, "transition" => transition}) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "#{id}/#{transition}")
  end

  def delete(conn, %{"id" => id}) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "#{id}")
  end
end
