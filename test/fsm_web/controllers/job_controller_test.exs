defmodule FsmWeb.JobControllerTest do
  use FsmWeb.ConnCase
  
  test "POST /api/create", %{conn: conn} do
    response = post(conn, "/api/create")
    assert text_response(response, 201) =~ "-"
  end

  test "GET /api/retrieve", %{conn: conn} do
    {:ok, id} = PersistentJob.create()
    response = get(conn, "/api/retrieve/#{id}")
    assert text_response(response, 200) =~ "created"
  end

  test "PATCH /api/update", %{conn: conn} do
    {:ok, id} = PersistentJob.create()
    response = patch(conn, "/api/update/#{id}?transition=start")
    assert text_response(response, 200) =~ "initialized"
  end

  test "DELETE /api/delete", %{conn: conn} do
    {:ok, id} = PersistentJob.create()
    response = delete(conn, "/api/delete/#{id}")
    assert text_response(response, 200) =~ "deleted"
  end

  test "PATCH /api/update (invalid state)", %{conn: conn} do
    {:ok, id} = PersistentJob.create()
    response = patch(conn, "/api/update/#{id}?transition=xxx")
    assert response.status == 400
  end

  test "GET /api/retrieve (invalid id)", %{conn: conn} do
    response = get(conn, "/api/retrieve/#{Ecto.UUID.generate()}")
    assert response.status == 400
  end

  test "PATCH /api/update (invalid id)", %{conn: conn} do
    response = patch(conn, "/api/update/#{Ecto.UUID.generate()}?transition=xxx")
    assert response.status == 400
  end

  test "DELETE /api/delete (invalid id)", %{conn: conn} do
    response = delete(conn, "/api/delete/#{Ecto.UUID.generate()}")
    assert text_response(response, 400) =~ "invalid id"
  end
end
