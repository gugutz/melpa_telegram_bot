defmodule PackagesBot.Archive do
  use GenServer

  alias PackagesBot.Packages

  require Logger

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    Logger.info("[#{__MODULE__}] Running.")

    {:ok, state, {:continue, :update_archive}}
  end

  def handle_continue(:update_archive, state) do
    update_archive()

    {:noreply, state}
  end

  def handle_info(:update_archive, state) do
    update_archive()

    {:noreply, state}
  end

  defp update_archive do
    Logger.info("[#{__MODULE__}] Updating archive.")

    {packages_renewed, _} = Packages.renew_packages()
    Logger.info("[#{__MODULE__}] Updated #{packages_renewed} packages.")

    {packages_downloads_renewed, _} = Packages.renew_download_counts()
    Logger.info("[#{__MODULE__}] Updated #{packages_downloads_renewed} download counts.")

    schedule_update()
  end

  defp schedule_update do
    Process.send_after(self(), :update_archive, renew_interval())
  end

  defp renew_interval do
    :packages_bot
    |> Application.fetch_env!(__MODULE__)
    |> Keyword.fetch!(:renew_interval_in_seconds)
    |> :timer.seconds()
  end
end
