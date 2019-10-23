defmodule CommitteeTest do
  use ExUnit.Case
  import Committee.TestHelpers

  test "greets the world", context do
    in_tmp(context.test, fn ->
      System.cmd("git", ["init"])
      Mix.Tasks.Committee.Install.run([])

      assert File.exists?(".committee.exs") == true

      assert File.exists?(".git/hooks/pre-commit") == true
      assert File.exists?(".git/hooks/post-commit") == true

      assert executable?(".git/hooks/pre-commit") == true
      assert executable?(".git/hooks/post-commit") == true
    end)
  end

  test "non git repo"
  test ".committee.exs already exists"
  test "existing hooks"
end
