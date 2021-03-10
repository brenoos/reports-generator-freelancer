defmodule ReportsGeneratorFreelancer do
  alias ReportsGeneratorFreelancer.Parser

  @developers [
    "Daniele",
    "Mayk",
    "Giuliano",
    "Cleiton",
    "Jakeliny",
    "Joseph"
  ]

  @months_map %{
    1 => "Janeiro",
    2 => "Fevereiro",
    3 => "Março",
    4 => "Abril",
    5 => "Maio",
    6 => "Junho",
    7 => "Julho",
    8 => "Agosto",
    9 => "Setembro",
    10 => "Outubro",
    11 => "Novembro",
    12 => "Dezembro"
  }

  @months_list [
    "Janeiro",
    "Fevereiro",
    "Março",
    "Abril",
    "Maio",
    "Junho",
    "Julho",
    "Agosto",
    "Setembro",
    "Outubro",
    "Novembro",
    "Dezembro"
  ]

  def build(file_name) do
    file_name
    |> Parser.parse_file()
    |> build_yearly_hours()
  end

  defp build_all_hours(parsed_file) do
    parsed_file
    |> Enum.reduce(report_acc_day(), fn line, acc ->
      sum_all_hours(line, acc)
    end)
  end

  defp build_monthly_hours(parsed_file) do
    parsed_file
    |> Enum.reduce(report_acc_month(), fn line, acc ->
      sum_monthly_hours(line, acc)
    end)
  end

  defp build_yearly_hours(parsed_file) do
    parsed_file
    |> Enum.reduce(report_acc_year(), fn line, acc ->
      sum_yearly_hours(line, acc)
    end)
  end

  defp report_acc_day() do
    Enum.into(@developers, %{}, &{&1, 0})
  end

  defp report_acc_month() do
    months = Enum.into(@months_list, %{}, &{&1, 0})
    Enum.into(@developers, %{}, &{&1, months})
  end

  defp report_acc_year() do
    months = Enum.into(2016..2020, %{}, &{&1, 0})
    Enum.into(@developers, %{}, &{&1, months})
  end

  defp sum_all_hours([name, hours, _day, _month, _year], acc) do
    %{acc | name => acc[name] + hours}
  end

  defp sum_monthly_hours([name, hours, _day, month, _year], acc) do
    %{acc | name => %{acc[name] | @months_map[month] => acc[name][@months_map[month]] + hours}}
  end

  defp sum_yearly_hours([name, hours, _day, _month, year], acc) do
    %{acc | name => %{acc[name] | year => acc[name][year] + hours}}
  end
end
