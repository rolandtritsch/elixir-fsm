defmodule FsmWeb.JobControllerTest do
  use FsmWeb.ConnCase

  test "GET /create", %{conn: conn} do
    conn = get(conn, "/create")
    assert text_response(conn, 201) =~ "-"
  end

  test "GET /retrieve", %{conn: conn} do
    id = Ecto.UUID.generate()
    conn = get(conn, "/retrieve/#{id}")
    assert text_response(conn, 200) =~ "#{id}"
  end

  test "GET /udpate", %{conn: conn} do
    id = Ecto.UUID.generate()
    conn = get(conn, "/update/#{id}?transition=start")
    assert text_response(conn, 200) =~ "#{id}/start"
  end

  test "GET /delete", %{conn: conn} do
    id = Ecto.UUID.generate()
    conn = get(conn, "/delete/#{id}")
    assert text_response(conn, 200) =~ "#{id}"
  end
end
