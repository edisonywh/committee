defmodule Mix.Tasks.Committee.Install do
  use Mix.Task

  @shortdoc "Creates a `commit.exs` file and generate executable for git hooks."

  @config_path "./commit.exs"
  @target_path ".git/hooks"

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
    defmodule YourApp.Commit do
      use Committee
      import Committee.Helpers, only: [staged_files: 0]

      # Here's where you can add your Git hooks!
      #
      # To abort a commit, return in the form of `{:halt, reason}`.
      # To print a success message, return in the form of `{:ok, message}`.
      #
      # ## Example:
      #
      #   # This function auto-runs `mix format` on staged files.
      #   @impl true
      #   def pre_commit do
      #     System.cmd("mix", ["format"] ++ staged_files())
      #     System.cmd("git", ["add"] ++ staged_files())
      #   end
      #
      # If you want to test your example manually, you can run:
      #
      #   `mix committee.runner [pre_commit | post_commit]`
      #
    end
    """)
  end
end
