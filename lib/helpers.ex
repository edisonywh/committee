defmodule Committee.Helpers do
  @moduledoc """
  This module provides helper functions to make working with git easier
  with functions like `staged_files/0`.
  """

  @doc """
  This function returns a list of staged files
  """
  @spec staged_files() :: list(String.t())
  def staged_files do
    System.cmd("git", ["diff", "--name-only", "--cached"])
    |> elem(0)
    |> String.split("\n", trim: true)
  end

  @spec branch_name() :: binary
  def branch_name do
    System.cmd("git", ["rev-parse", "--abbrev-ref", "HEAD"])
    |> elem(0)
    |> String.trim()
  end
end
