defmodule Timeularex do
  @moduledoc """
  API wrapper for the Timeular public API

  http://developers.timeular.com/public-api/
  """
  use Application

  alias Timeularex.API
  alias Timeularex.Config

  def start(_type, _args) do
    children = []

    opts = [strategy: :one_for_one, name: Timeularex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def activities do
    with {:ok, token} <- access_token(),
         {:ok, %HTTPoison.Response{body: body}} <-
           API.get("/activities", Authorization: "Bearer #{token}") do
      {:ok, body}
    else
      _ -> {:error}
    end
  end

  def access_token do
    %{
      apiKey: Config.api_key(),
      apiSecret: Config.api_secret()
    }
    |> sign_in
  end

  defp sign_in(body) do
    response =
      ~s(/developer/sign-in)
      |> API.post(body, [])

    case response do
      {:ok, %HTTPoison.Response{body: body}} -> {:ok, body["token"]}
      _ -> {:error}
    end
  end
end
