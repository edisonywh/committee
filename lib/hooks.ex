defmodule Committee.Hooks do
  @moduledoc """
  Helper functions for handling git hooks.
  """

  @hooks Committee.__hooks__()
  @target_path ".git/hooks"

  @doc """
  Create the hooks files, backing up existing ones.
  """
  def create_hooks(hooks \\ @hooks) when is_list(hooks) do
    for_each_hook(hooks, &create_hook/2)
  end

  defp create_hook(file, hook) when hook in @hooks do
    if File.exists?(file) do
      File.rename!(file, "#{file}.old")
      Mix.shell().info("Existing #{hook} file renamed to #{file}.old..")
    end

    File.write!(file, template_for(hook))
    make_executable(file)
  end

  @doc """
  Remove the hooks files.
  """
  def remove_hooks(hooks \\ @hooks) when is_list(hooks) do
    Mix.shell().info("Looking for hooks to delete..")
    for_each_hook(hooks, &remove_hook/2)
  end

  defp remove_hook(file, _hook) do
    if File.exists?(file) do
      Mix.shell().info("Removing #{file}..")
      File.rm!(file)
    else
      Mix.shell().info("#{file} not found..")
    end
  end

  @doc """
  Restore the hooks backups.
  """
  def restore_backups(hooks \\ @hooks) when is_list(hooks) do
    Mix.shell().info("Looking for backed up hooks to restore..")
    for_each_hook(hooks, &restore_backup/2)
  end

  defp restore_backup(file, _hook) do
    backup_file = "#{file}.old"

    if File.exists?(backup_file) do
      Mix.shell().info("Restoring #{backup_file}..")
      File.rename!(backup_file, file)
    else
      Mix.shell().info("#{backup_file} not found..")
    end
  end

  # Helper function to iterate over hooks and perform some operation
  defp for_each_hook(hooks, func) do
    Enum.each(hooks, fn hook ->
      @target_path
      |> Path.join(snake_to_kebab(hook))
      |> func.(hook)
    end)
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
end
