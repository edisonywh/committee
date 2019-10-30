defmodule Mix.Tasks.Committee.Uninstall do
  use Mix.Task
  alias Committee.Hooks

  @shortdoc "Remove files created by `mix committee.install` and restores the backup"

  @config_path "./.committee.exs"

  @impl true
  def run(_) do
    remove_config_file()
    Hooks.remove_hooks()
    Hooks.restore_backups()
  end

  defp remove_config_file do
    case File.exists?(@config_path) do
      true ->
        Mix.shell().info("Removing `.committee.exs` now..")
        File.rm!(@config_path)

      false ->
        Mix.shell().info("`.committee.exs` not found..")
    end
  end
end
