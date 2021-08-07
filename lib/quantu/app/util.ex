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

  def camelize(val) when is_struct(val), do: val

  def camelize(val) when is_map(val) do
    for({k, v} <- val, into: %{}) do
      {camelize_word(to_string(k)), camelize(v)}
    end
  end

  def camelize(val) when is_list(val), do: Enum.map(val, &camelize/1) |> Enum.to_list()
  def camelize(val), do: val

  def camelize_word(word, option \\ :lower) do
    case Regex.split(~r/(?:^|[-_])|(?=[A-Z])/, to_string(word)) do
      words ->
        words
        |> Enum.filter(&(&1 != ""))
        |> camelize_list(option)
        |> Enum.join()
    end
  end

  defp camelize_list([], _), do: []

  defp camelize_list([h | tail], :lower) do
    [lowercase(h)] ++ camelize_list(tail, :upper)
  end

  defp camelize_list([h | tail], :upper) do
    [capitalize(h)] ++ camelize_list(tail, :upper)
  end

  def capitalize(word), do: String.capitalize(word)
  def lowercase(word), do: String.downcase(word)
end
