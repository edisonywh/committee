defmodule Mix.Tasks.Committee.Install do
  use Mix.Task

  @shortdoc "Creates a `commit.exs` file and generate executable for git hooks."

  @config_file_name "commit.exs"
  @config_path Path.expand(@config_file_name)
  @target_path Path.expand(".git/hooks")

  @hooks Committee.__hooks__()

  @impl true
  def run(_) do
    case File.exists?(@config_path) do
      true ->
        Mix.shell().info("You already have a `commit.exs`! Happy committing :)")

      false ->
        Mix.shell().info("Generating `commit.exs` now..")
        create_config_file()

        Mix.shell().info("Generating git hooks now..")
        create_git_hooks()
    end
  end

  defp create_git_hooks(), do: @hooks |> create_hooks()

  defp create_hooks(hooks) when is_list(hooks) do
    Enum.map(hooks, fn hook ->
      @target_path
      |> Path.join(snake_to_kebab(hook))
      |> create_hook(hook)
    end)
  end

  defp create_hook(file, hook) when hook in @hooks do
    File.write!(file, template_for(hook))

    make_executable(file)
  end

  defp template_for(hook) do
    ~s"""
    #!/bin/sh

    mix committee.runner #{hook}
    """
  end

  defp make_executable(file), do: System.cmd("chmod", ["+x", file])

  # Git hooks have to be in kebab case
  defp snake_to_kebab(string) when is_binary(string) do
    string |> String.replace("_", "-")
  end

  defp create_config_file do
    @config_path
    |> File.write!(~S"""
    defmodule YourApp.Commitment do
      use Committee

      # Here's where you can add your Git hooks!
      # Return with a non-zero exit code if you want to fail the commit.
      #
      # ## Example:
      #
      #   def pre_commit,  do: exit({:shutdown, 1})
      #
      # If you want to test your example manually, you can run:
      #
      #   `mix committee.runner [pre_commit | post_commit]`
      #
    end
    """)
  end
end
