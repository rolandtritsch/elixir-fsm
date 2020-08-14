defmodule FsmWeb.JobControllerTest do
  use FsmWeb.ConnCase
  
  test "GET /create", %{conn: conn} do
    response = get(conn, "/create")
    assert text_response(response, 201) =~ "-"
  end

  test "GET /retrieve", %{conn: conn} do
    {:ok, id} = PersistentJob.create()
    response = get(conn, "/retrieve/#{id}")
    assert text_response(response, 200) =~ "created"
  end

  test "GET /update", %{conn: conn} do
    {:ok, id} = PersistentJob.create()
    response = get(conn, "/update/#{id}?transition=start")
    assert text_response(response, 200) =~ "initialized"
  end

  test "GET /delete", %{conn: conn} do
    {:ok, id} = PersistentJob.create()
    response = get(conn, "/delete/#{id}")
    assert text_response(response, 200) =~ "deleted"
  end

  test "GET /update (invalid state)", %{conn: conn} do
    {:ok, id} = PersistentJob.create()
    response = get(conn, "/update/#{id}?transition=xxx")
    assert response.status == 400
  end

  test "GET /retrieve (invalid id)", %{conn: conn} do
    response = get(conn, "/retrieve/#{Ecto.UUID.generate()}")
    assert response.status == 400
  end

  test "GET /update (invalid id)", %{conn: conn} do
    response = get(conn, "/update/#{Ecto.UUID.generate()}?transition=xxx")
    assert response.status == 400
  end

  test "GET /delete (invalid id)", %{conn: conn} do
    response = get(conn, "/delete/#{Ecto.UUID.generate()}")
    assert text_response(response, 400) =~ "invalid id"
  end
end
