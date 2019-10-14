defmodule Mix.Tasks.Committee.Install do
  use Mix.Task
  alias Committee.Hooks

  @shortdoc "Creates a `commit.exs` file and generate executable for git hooks."

  @config_path "./commit.exs"

  @impl true
  def run(_) do
    case File.exists?(@config_path) do
      true ->
        Mix.shell().info("You already have a `commit.exs`! Happy committing :)")

      false ->
        Mix.shell().info("Generating `commit.exs` now..")
        create_config_file()

        Mix.shell().info("Generating git hooks now..")
        Hooks.create_hooks()
    end
  end

  defp create_config_file do
    @config_path
    |> File.write!(~s"""
    defmodule YourApp.Commit do
      use Committee
      import Committee.Helpers, only: [staged_files: 0, staged_files: 1]

      # Here's where you can add your Git hooks!
      #
      # To abort a commit, return in the form of `{:halt, reason}`.
      # To print a success message, return in the form of `{:ok, message}`.
      #
      # ## Example:
      #
      #   @impl true
      #   @doc \"\"\"
      #   This function auto-runs `mix format` on staged files.
      #   \"\"\"
      #   def pre_commit do
      #     System.cmd("mix", ["format"] ++ staged_files([".ex", ".exs"]))
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
