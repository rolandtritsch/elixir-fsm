defmodule FsmWeb.ApiSpec do
  alias OpenApiSpex.{Info, OpenApi, Paths, Server, Contact}
  alias FsmWeb.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        # Populate the Server info from a phoenix endpoint
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: Application.spec(:fsm, :description) |> to_string(),
        description: """
          https://github.com/rolandtritsch/elixir-fsm

          An application to experiment with different FSM implementations.
        """,
        version: Application.spec(:fsm, :vsn) |> to_string(),
        contact: %Contact{
          name: "Roland Tritsch",
          email: "roland@tritsch.org",
          url: "https://github.com/rolandtritsch/elixir-fsm"
        }
      },
      # Populate the paths from a phoenix router
      paths: Paths.from_router(Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
