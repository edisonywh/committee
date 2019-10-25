defmodule Committee.HelpersTest do
  use ExUnit.Case
  import Committee.TestHelpers
  alias Committee.Helpers

  describe "staged_files/0" do
    test "returns the staged files", context do
      in_tmp(context.test, fn ->
        System.cmd("git", ["init"])

        assert Helpers.staged_files() == []
        File.touch!("file.txt")
        assert Helpers.staged_files() == []
        System.cmd("git", ["add", "file.txt"])
        assert Helpers.staged_files() == ["file.txt"]
      end)
    end
  end

  describe "staged_files/1" do
    test "returns the staged files filtered by extension", context do
      in_tmp(context.test, fn ->
        System.cmd("git", ["init"])

        File.touch!("file.txt")
        System.cmd("git", ["add", "file.txt"], into: "")
        assert Helpers.staged_files(".exs") == []

        File.touch!("file.exs")
        System.cmd("git", ["add", "file.exs"])
        assert Helpers.staged_files(".exs") == ["file.exs"]
      end)
    end
  end

  describe "branch_name/0" do
    test "returns the current branch name", context do
      in_tmp(context.test, fn ->
        System.cmd("git", ["init"])
        System.cmd("git", ["commit", "--allow-empty", "-m", "'Initial commit'"])

        assert Helpers.branch_name() == "master"

        System.cmd("git", ["checkout", "-b", "my-cool-branch"])

        assert Helpers.branch_name() == "my-cool-branch"
      end)
    end
  end
end
