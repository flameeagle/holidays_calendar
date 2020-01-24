require 'csv'
require 'date'

input_filename = 'data_holidays.csv'
output_dir = './'
need_year = "2020"

if ARGV.length >= 1
  need_year = ARGV[0]
end
#найти индекс в массиве ссответствующий требуемому году need_year
csv_text = File.read(input_filename)
csv = CSV.parse(csv_text, :headers => true)
year_index = csv.to_a.transpose[0].index(need_year)
holidays_in_year = []
#парсинг массива для получения смещения в днях
csv[year_index-1].to_a.slice(1,12).each.with_index do |month_array, index|
  month_array[1].split(',').each do |day_element|
    #если это просто короткий день, то пропустить его (возможно когда-нибудь придется следить за рабочим временем, тогда можно отдельно выгрузить)
    next if !day_element.match('\d+\*').nil?
    parse_day = day_element.gsub(/\+|\*/,'')
    day_in_year = Date.new(y=need_year.to_i,m=index+1,d=parse_day.to_i).yday
    #puts parse_day + "." + (index+1).to_s + "." + need_year + " - " + day_in_year.to_s
    puts day_in_year.to_s
    holidays_in_year.push(day_in_year)
  end
end
File.write(output_dir + need_year + ".csv", holidays_in_year.join("\n"), mode: "w")
