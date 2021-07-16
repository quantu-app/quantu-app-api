defmodule Quantu.App.Util do
  def generate_token(length), do: :crypto.strong_rand_bytes(length) |> Base.url_encode64()

  def blank?(nil), do: true
  def blank?(val) when val == %{}, do: true
  def blank?(val) when val == [], do: true
  def blank?(val) when is_binary(val), do: String.trim(val) == ""
  def blank?(_val), do: false

  def underscore(val) when is_struct(val), do: val

  def underscore(val) when is_map(val) do
    for({k, v} <- val, into: %{}) do
      {Macro.underscore(to_string(k)), underscore(v)}
    end
  end

  def underscore(val) when is_list(val), do: Enum.map(val, &underscore/1) |> Enum.to_list()
  def underscore(val), do: val
end
