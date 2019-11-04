defmodule Mix.Tasks.Committee.Install do
  use Mix.Task

  @shortdoc "Creates a `.committee.exs` file"

  @config_path "./.committee.exs"

  @impl true
  def run(_) do
    case File.exists?(@config_path) do
      true ->
        Mix.shell().info("You already have a `.committee.exs`! Happy committing :)")

      false ->
        Mix.shell().info("Generating `.committee.exs` now..")
        create_config_file()
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
