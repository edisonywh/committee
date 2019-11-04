ExUnit.start()

defmodule Committee.TestHelpers do
  def in_tmp(which, function) do
    path = tmp_path(which)
    File.rm_rf!(path)
    File.mkdir_p!(path)
    File.cd!(path, function)
  end

  def executable?(file) do
    cmd = String.to_charlist("test -x #{file} && echo true || echo false")

    :os.cmd(cmd) == 'true\n'
  end

  defp tmp_path(which) do
    "../tmp"
    |> Path.expand(__DIR__)
    |> Path.join(to_string(which))
  end
end

defmodule Committee.MixTaskStub do
  def run(task) do
    send(self(), task)
  end
end
