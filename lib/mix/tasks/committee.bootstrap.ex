defmodule Mix.Tasks.Committee.Bootstrap do
  use Mix.Task

  @shortdoc "Creates a `.committee.exs` file and generate executable for git hooks."

  @impl true
  def run([]) do
    do_run(Mix.Task)
  end

  @impl true
  def run([runner]) do
    do_run(runner)
  end

  defp do_run(runner) do
    runner.run("committee.install")
    runner.run("committee.install_hooks")
  end
end
