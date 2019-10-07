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
        apply(mod, String.to_atom(hook), [])
      false ->
        Mix.shell().error("Unrecognized hook command, available options are ['#{Enum.join(@hooks, ", ")}']")
    end
  end
end
