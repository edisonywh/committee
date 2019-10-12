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
    System.cmd("git", ["diff", "-z", "--name-only", "--staged"])
    |> elem(0)
    |> String.split("\0", trim: true)
  end

  @doc """
  This function returns a list of staged files, but takes in a list of atoms/strings
  to return by file extensions.
  """
  @spec staged_files(String.t() | list(String.t())) :: list(String.t())
  def staged_files(ext) do
    staged_files()
    |> Enum.filter(&String.ends_with?(&1, ext))
  end

  @spec branch_name() :: binary
  def branch_name do
    System.cmd("git", ["rev-parse", "--abbrev-ref", "HEAD"])
    |> elem(0)
    |> String.trim()
  end
end
