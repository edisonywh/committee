defmodule Mix.Tasks.Committee.Runner do
  use Mix.Task

  @shortdoc "Runner for Git hooks"
  @config_file_name "commit.exs"
  @hooks Committee.__hooks__()

  @impl true
  def run(argv) do
    {mod, _bytecode} = Code.compile_file(@config_file_name) |> hd
    hook = hd(argv)

    case hook in @hooks do
      true ->
        case apply(mod, String.to_atom(hook), []) do
          {:ok, message} ->
            Mix.shell().info(message)

          {:halt, reason} ->
            Mix.shell().error("`#{hook}` hook exited with reason: \"#{reason}\"")
            exit({:shutdown, 1})

          _ ->
            nil
        end

      false ->
        Mix.shell().error(
          "Unrecognized hook command, available options are ['#{Enum.join(@hooks, ", ")}']"
        )
    end
  end
end
