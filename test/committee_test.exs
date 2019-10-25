defmodule CommitteeTest do
  use ExUnit.Case
  import Committee.TestHelpers

  setup do
    Mix.shell(Mix.Shell.Process)

    :ok
  end

  describe "install" do
    test "install the hooks", context do
      in_tmp(context.test, fn ->
        System.cmd("git", ["init"])

        Mix.Tasks.Committee.Install.run([])

        assert_received {:mix_shell, :info, ["Generating `.committee.exs` now.."]}
        assert_received {:mix_shell, :info, ["Generating git hooks now.."]}

        assert File.read!(".committee.exs") =~ "use Committee"
        assert File.read!(".git/hooks/pre-commit") =~ "mix committee.runner pre_commit"
        assert File.read!(".git/hooks/post-commit") =~ "mix committee.runner post_commit"

        assert executable?(".git/hooks/pre-commit") == true
        assert executable?(".git/hooks/post-commit") == true
      end)
    end

    test ".committee.exs already exists", context do
      in_tmp(context.test, fn ->
        System.cmd("git", ["init"])
        File.touch!(".committee.exs")

        Mix.Tasks.Committee.Install.run([])

        assert_received {:mix_shell, :info,
                         ["You already have a `.committee.exs`! Happy committing :)"]}

        assert File.exists?(".git/hooks/pre-commit") == false
        assert File.exists?(".git/hooks/post-commit") == false
      end)
    end

    test "existing hooks", context do
      in_tmp(context.test, fn ->
        System.cmd("git", ["init"])
        File.touch!(".git/hooks/pre-commit")
        File.touch!(".git/hooks/post-commit")

        Mix.Tasks.Committee.Install.run([])

        assert_received {:mix_shell, :info, ["Generating `.committee.exs` now.."]}
        assert_received {:mix_shell, :info, ["Generating git hooks now.."]}

        assert_received {:mix_shell, :info,
                         ["Existing pre_commit file renamed to .git/hooks/pre-commit.old.."]}

        assert_received {:mix_shell, :info,
                         ["Existing post_commit file renamed to .git/hooks/post-commit.old.."]}

        assert File.exists?(".git/hooks/pre-commit.old") == true
        assert File.exists?(".git/hooks/post-commit.old") == true

        assert File.read!(".committee.exs") =~ "use Committee"
        assert File.read!(".git/hooks/pre-commit") =~ "mix committee.runner pre_commit"
        assert File.read!(".git/hooks/post-commit") =~ "mix committee.runner post_commit"
      end)
    end
  end
end
