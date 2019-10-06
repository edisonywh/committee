defmodule Committee do
  @hooks ~w(pre_commit post_commit)

  @moduledoc """
  This module exposes a `__using__/1` that injects default implementation of git hooks
  such as `#{Enum.join(@hooks, ", ")}`.

  Users are expected to override them in `commit.exs` (created via `mix committee.install`).
  """
  defmacro __using__(_opts) do
    quote do
      @behaviour Committee

      @doc false
      @spec pre_commit() :: no_return
      def pre_commit,  do: exit({:shutdown, 0})

      @doc false
      @spec post_commit() :: no_return
      def post_commit, do: exit({:shutdown, 0})

      defoverridable pre_commit: 0, post_commit: 0
    end
  end

  @callback pre_commit()  :: no_return
  @callback post_commit() :: no_return
end
