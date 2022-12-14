defmodule Scrapper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Scrapper.Cover, %{
        id: Tiempo,
        base_url: "http://tiempo.com.mx",
        regex_url: ~r/\/noticia\/\w+\//
      }}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Scrapper.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
