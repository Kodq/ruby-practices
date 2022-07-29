require 'date'
require 'optparse'

params = ARGV.getopts("","y:#{Date.today.year}", "m:#{Date.today.month}")
firstday = Date.new(params["y"].to_i,params["m"].to_i,1)
lastday = Date.new(params["y"].to_i,params["m"].to_i,-1)
range = (firstday.mday..lastday.mday)
space = "   "

puts("#{params["m"]}月 #{params["y"]}".center(20))
puts("日 月 火 水 木 金 土")

6.times do |t|
  if t == firstday.wday.to_i
    print(space * t)
    break
  end 
end

range.each do |day|
  printf("%2d",day)
  print(" ")
  if Date.new(params["y"].to_i,params["m"].to_i,day).wday == 6
    puts()
  end
end



