defmodule Committee do
  @hooks ~w(pre_commit post_commit)
  @version "1"

  @doc """
  Return a list of the currently supported hooks.
  """
  def __hooks__, do: @hooks

  @doc """
  Return the current version of Committee
  """
  def __version__, do: @version

  @moduledoc """
  This module exposes a `__using__/1` that injects default implementation of git hooks
  such as `#{Enum.join(@hooks, ", ")}`.

  Users are expected to override them in `.committee.exs` (created via `mix committee.install`).
  """
  defmacro __using__(_opts) do
    quote do
      @behaviour Committee

      @impl true
      @spec pre_commit() :: {:ok, String.t()} | {:halt, String.t()} | any()
      def pre_commit, do: exit({:shutdown, 0})

      @impl true
      @spec post_commit() :: {:ok, String.t()} | {:halt, String.t()} | any()
      def post_commit, do: exit({:shutdown, 0})

      defoverridable pre_commit: 0, post_commit: 0
    end
  end

  @callback pre_commit() :: no_return
  @callback post_commit() :: no_return
end
