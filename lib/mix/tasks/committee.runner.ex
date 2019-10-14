defmodule Mix.Tasks.Committee.Runner do
  use Mix.Task

  @shortdoc "Runner for Git hooks"
  @config_file_name "commit.exs"
  @hooks Committee.__hooks__()

  @impl true
  def run(argv) do
    hook = hd(argv)

    with {:file, true} <- {:file, File.exists?(@config_file_name)},
         {:compile, {mod, _bytecode}} = {:compile, hd(Code.compile_file(@config_file_name))},
         {:hook, true} <- {:hook, hook in @hooks},
         {:exec, {:ok, message}} <- {:exec, apply(mod, String.to_atom(hook), [])} do
      Mix.shell().info("=== ⚡️ Committee is running your `#{hook}` hook! ===\n")
      Mix.shell().info(message)
      Mix.shell().info("\n=== ⚡️ `#{hook}` ran! ===\n")
    else
      {:file, false} ->
        Mix.shell().info(~s"""
        Committee needs a `#{@config_file_name}` in order to work, but you don't seem to have one.
        If you want to remove Committee, you can run the built-in `mix committee.uninstall` to cleanly uninstall it.
        """)

      {:hook, false} ->
        Mix.shell().error(
          "Unrecognized hook command, available options are ['#{Enum.join(@hooks, ", ")}']"
        )

      {:exec, {:halt, reason}} ->
        Mix.shell().error("`#{hook}` hook exited with reason: \"#{reason}\"")
        exit({:shutdown, 1})

      _ ->
        nil
    end
  end
end
