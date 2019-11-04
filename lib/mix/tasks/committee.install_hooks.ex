defmodule Mix.Tasks.Committee.InstallHooks do
  use Mix.Task
  alias Committee.Hooks

  @shortdoc "Generates executable for git hooks."

  @impl true
  def run(_) do
    Mix.shell().info("Generating git hooks now..")
    Hooks.create_hooks()
  end
end
