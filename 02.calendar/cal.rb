require 'date'
require 'optparse'

params = ARGV.getopts("","y:#{Date.today.year}", "m:#{Date.today.month}")
first_day = Date.new(params["y"].to_i,params["m"].to_i,1)
last_day = Date.new(params["y"].to_i,params["m"].to_i,-1)
range = (first_day..last_day)
space = "   "

puts("#{params["m"]}月 #{params["y"]}".center(20))
puts("日 月 火 水 木 金 土")

6.times do |t| 
  if t == first_day.wday.to_i
    print(space * first_day.wday.to_i)
    break
  end 
end

range.each do |day|
  printf("%2d",day.mday)
  print(" ")
  if day.wday == 6
    puts
  end
end



