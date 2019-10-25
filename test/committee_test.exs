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

  describe "uninstall" do
    test "uninstall the hooks", context do
      in_tmp(context.test, fn ->
        System.cmd("git", ["init"])

        hook_content = """
        #!/bin/sh
        echo 'hook'
        """

        backup_content = """
        #!/bin/sh
        echo 'backup'
        """

        File.touch!(".committee.exs")
        File.write!(".git/hooks/pre-commit", hook_content)
        File.write!(".git/hooks/post-commit", hook_content)
        File.write!(".git/hooks/pre-commit.old", backup_content)
        File.write!(".git/hooks/post-commit.old", backup_content)

        Mix.Tasks.Committee.Uninstall.run([])

        assert_received {:mix_shell, :info, ["Removing `.committee.exs` now.."]}
        assert_received {:mix_shell, :info, ["Looking for hooks to delete.."]}
        assert_received {:mix_shell, :info, ["Removing .git/hooks/pre-commit.."]}
        assert_received {:mix_shell, :info, ["Removing .git/hooks/post-commit.."]}
        assert_received {:mix_shell, :info, ["Looking for backed up hooks to restore.."]}
        assert_received {:mix_shell, :info, ["Restoring .git/hooks/pre-commit.old.."]}
        assert_received {:mix_shell, :info, ["Restoring .git/hooks/post-commit.old.."]}

        assert File.exists?(".committee.exs") == false

        assert File.exists?(".git/hooks/pre-commit.old") == false
        assert File.exists?(".git/hooks/post-commit.old") == false

        assert File.read!(".git/hooks/pre-commit") == backup_content
        assert File.read!(".git/hooks/post-commit") == backup_content
      end)
    end

    test ".committee.exs not found", context do
      in_tmp(context.test, fn ->
        System.cmd("git", ["init"])

        hook_content = """
        #!/bin/sh
        echo 'hook'
        """

        backup_content = """
        #!/bin/sh
        echo 'backup'
        """

        File.write!(".git/hooks/pre-commit", hook_content)
        File.write!(".git/hooks/post-commit", hook_content)
        File.write!(".git/hooks/pre-commit.old", backup_content)
        File.write!(".git/hooks/post-commit.old", backup_content)

        Mix.Tasks.Committee.Uninstall.run([])

        assert_received {:mix_shell, :info, ["`.committee.exs` not found.."]}
      end)
    end

    test "hooks not found", context do
      in_tmp(context.test, fn ->
        System.cmd("git", ["init"])

        backup_content = """
        #!/bin/sh
        echo 'backup'
        """

        File.touch!(".committee.exs")
        File.write!(".git/hooks/pre-commit.old", backup_content)
        File.write!(".git/hooks/post-commit.old", backup_content)

        Mix.Tasks.Committee.Uninstall.run([])

        assert_received {:mix_shell, :info, [".git/hooks/pre-commit not found.."]}
        assert_received {:mix_shell, :info, [".git/hooks/post-commit not found.."]}
      end)
    end

    test "backups not found", context do
      in_tmp(context.test, fn ->
        System.cmd("git", ["init"])

        hook_content = """
        #!/bin/sh
        echo 'hook'
        """

        File.touch!(".committee.exs")
        File.write!(".git/hooks/pre-commit", hook_content)
        File.write!(".git/hooks/post-commit", hook_content)

        Mix.Tasks.Committee.Uninstall.run([])

        assert_received {:mix_shell, :info, [".git/hooks/pre-commit.old not found.."]}
        assert_received {:mix_shell, :info, [".git/hooks/post-commit.old not found.."]}

        assert File.exists?(".git/hooks/pre-commit") == false
        assert File.exists?(".git/hooks/post-commit") == false
      end)
    end
  end
end
