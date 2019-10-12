defmodule Mix.Tasks.Committee.Runner do
  use Mix.Task

  @shortdoc "Runner for Git hooks"
  @config_file_name "commit.exs"
  @hooks Committee.__hooks__()

  @impl true
  def run(argv) do
    if not File.exists?(@config_file_name) do
      Mix.shell().error("#{@config_file_name} does not exist!")
      exit({:shutdown, 1})
    end

    {mod, _bytecode} = Code.compile_file(@config_file_name) |> hd
    hook = hd(argv)

    case hook in @hooks do
      true ->
        Mix.shell().info("=== ⚡️ Committee is running your `#{hook}` hook! ===\n")

        case apply(mod, String.to_atom(hook), []) do
          {:ok, message} ->
            Mix.shell().info(message)

          {:halt, reason} ->
            Mix.shell().error("`#{hook}` hook exited with reason: \"#{reason}\"")
            exit({:shutdown, 1})

          _ ->
            nil
        end

        Mix.shell().info("\n=== ⚡️ `#{hook}` ran! ===\n")

      false ->
        Mix.shell().error(
          "Unrecognized hook command, available options are ['#{Enum.join(@hooks, ", ")}']"
        )
    end
  end
end
