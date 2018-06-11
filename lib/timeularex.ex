defmodule Timeularex do
  @moduledoc """
  NOTE: Timeularex is in early stages of development. Use in production
  should be considered with caution.

  Timeularex is an API client for the [Timeular public API](http://developers.timeular.com/public-api/)

  Timular is a service to improve time-tracking of activities.

  ## Configuration

  The client provides two options for configuration. The first involves the
  typical setting of variables in your `config.exs` file:

      config :timeularex,
        api_key: <<API_KEY>>,
        api_secret: <<API_SECRET>>,
        api_url: "https://api.timeular.com/api/v2"

  Additionally, you can utilize api_key/1 and api_secret/1 functions in the
  `TImeularex.Config` module.

  Your API key and secret can be retrieved from your [account app settings](https://profile.timeular.com/#/app/account)
  """

  use Application

  alias Timeularex.Client
  alias Timeularex.Resources

  def start(_type, _args) do
    children = [
      Timeularex.Client
    ]

    opts = [strategy: :one_for_one, name: Timeularex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def init(_) do
    IO.puts("test")
  end

  # Timeular API

  @doc """
  List all the integrations associated with the connected account.
  """
  def integrations do
    "/integrations"
    |> Client.request(:get)
  end

  @doc """
  List all activities associated with the connected account.
  """
  def activities do
    "/activities"
    |> Client.request(:get)
  end

  @doc """
  Create a new Activity. The activity should have a name and color. A Name
  doesn’t have to be unique. Optionally, you can also provide an Integration
  to which the activity will belong to. You can obtain list of enabled
  Integrations with integrations/0.
  """
  def create_activity(%Resources.Activity{} = activity) do
    "/activities"
    |> Client.request(:post, activity)
  end

  @doc """
  Update an existing Activity's name and/or color.
  """
  def update_activity(%Resources.Activity{} = activity) do
    "/activities"
    |> Client.request(:patch, activity)
  end

  @doc """
  Archive an Activity. Time tracked with the Activity will be preserved.
  """
  def archive_activity(activity_id) do
    "/activities/#{activity_id}"
    |> Client.request(:delete)
  end

  @doc """
  Assign an Activity to a given device side.
  """
  def assign_side_activity(device_side, activity_id) do
    "/activities/#{activity_id}/device-side/#{device_side}"
    |> Client.request(:post)
  end

  @doc """
  Unassigns an Activity associated with a given device side.
  """
  def unassign_side_activity(device_side, activity_id) do
    "/activities/#{activity_id}/device-side/#{device_side}"
    |> Client.request(:delete)
  end

  @doc """
  List all archived Activities.
  """
  def archived_activities do
    "/archived_activities"
    |> Client.request(:get)
  end

  @doc """
  List all devices.
  """
  def devices do
    "/devices"
    |> Client.request(:get)
  end

  @doc """
  Sets the status of a device to active.
  """
  def activate_device(device_serial) do
    "/devices/#{device_serial}/active"
    |> Client.request(:post)
  end

  @doc """
  Sets the status of a device to inactive.
  """
  def deactivate_device(device_serial) do
    "/devices/#{device_serial}/active"
    |> Client.request(:delete)
  end

  @doc """
  Update the name of a device.
  """
  def update_device_name(device_serial, name) do
    "/devices/#{device_serial}"
    |> Client.request(:patch, %{name: name})
  end

  @doc """
  Remove a device from the list of known devices. Use activate_device/1 to
  make the device active again.
  """
  def remove_device(device_serial) do
    "/devices/#{device_serial}"
    |> Client.request(:delete)
  end

  @doc """
  Disable a device.
  """
  def disable_device(device_serial) do
    "/devices/#{device_serial}/disabled"
    |> Client.request(:post)
  end

  @doc """
  Enable a device.
  """
  def enable_device(device_serial) do
    "/devices/#{device_serial}/disabled"
    |> Client.request(:delete)
  end

  @doc """
  Returns information regarding what is currently being tracked.
  """
  def tracking do
    "/tracking"
    |> Client.request(:get)
  end

  @doc """
  Start tracking a given Activity.
  """
  def start_tracking(activity_id) do
    current_datetime = DateTime.utc_now() |> timeular_datetime_format

    "/tracking/#{activity_id}/start"
    |> Client.request(:post, %{startedAt: current_datetime})
  end

  @doc """
  Edit the notes associated an Activity being tracked.
  """
  def edit_tracking_note(activity_id, %Resources.Note{} = note) do
    "/tracking/#{activity_id}"
    |> Client.request(:patch, note)
  end

  @doc """
  Stop tracking a given Activity.
  """
  def stop_tracking(activity_id) do
    current_datetime = DateTime.utc_now() |> timeular_datetime_format()

    "/tracking/#{activity_id}/stop"
    |> Client.request(:post, %{stoppedAt: current_datetime})
  end

  @doc """
  Return all time entries that falls between a given time range.
  """
  def time_entries(stopped_after, started_before) do
    "/time-entries/#{stopped_after}/#{started_before}"
    |> Client.request(:get)
  end

  @doc """
  Return a time entry by ID.
  """
  def time_entry(entry_id) do
    "/time-entries/#{entry_id}"
    |> Client.request(:get)
  end

  def reports(start_timestamp, stop_timestamp) do
    "/report/#{start_timestamp}/#{stop_timestamp}"
    |> Client.request(:get)
  end

  def tags_and_mentions do
    "/tags-and-mentions"
    |> Client.request(:get)
  end

  # Helpers

  defp timeular_datetime_format(datetime) do
    datetime
    |> DateTime.truncate(:millisecond)
    |> DateTime.to_iso8601()
    |> String.trim_trailing("Z")
  end
end
