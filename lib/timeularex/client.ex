defmodule Timeularex.Client do
  use GenServer

  alias Timeularex.Config
  alias Timeularex.API

  # Client API

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, [name: __MODULE__])
  end

  def request(url, method) when method in [:get, :delete] do
    GenServer.call(__MODULE__, %{method: method, opts: [url]})
  end

  def request(url, method, body \\ "") when method in [:patch, :post, :put] do
    GenServer.call(__MODULE__, %{method: method, opts: [url, body]})
  end

  # Callbacks

  @impl true
  def init(_) do
    case get_access_token() do
      {:ok, token} -> {:ok, %{token: token}}
      {_, response} -> {:stop, response}
    end
  end

  @impl true
  def handle_call(%{method: method, opts: opts}, _from, state) do
    response = apply(API, method, opts ++ [[Authorization: "Bearer #{state.token}"]])

    case response do
      {:ok, %HTTPoison.Response{body: body, status_code: 200}} -> {:reply, {:ok, body}, state}
      {:ok, %HTTPoison.Response{body: body, status_code: 404}} -> {:reply, {:error, body.message}, %{}}
      {:ok, %HTTPoison.Response{body: body, status_code: 401}} -> {:stop, {:error, body.message}, %{}}
      unknown ->
        IO.inspect unknown
        {:stop, "unknown response received", %{}}
    end
  end

  # Helpers

  defp get_access_token do
    body = %{
      apiKey: Config.api_key,
      apiSecret: Config.api_secret
    }

    response =
      ~s(/developer/sign-in)
      |> API.post(body, [])

    case response do
      {:ok, %HTTPoison.Response{body: body}} -> {:ok, body["token"]}
      _ -> {:error, response}
    end
  end
end
