require 'date'
require 'optparse'

params = ARGV.getopts("","y:#{Date.today.year}", "m:#{Date.today.month}")
firstday = Date.new(params["y"].to_i,params["m"].to_i,1)
lastday = Date.new(params["y"].to_i,params["m"].to_i,-1)
range = (firstday.mday..lastday.mday)
week = 0

puts("#{params["m"]}月 #{params["y"]}".center(20))
puts("日 月 火 水 木 金 土")

7.times do |t|
  if t == firstday.strftime('%w').to_i
    week = t
    break
  end
  print("   ")
end

range.each do |day|
  printf("%2d",day)
  print(" ")
  week += 1
  if week == 7
    week = 0
    puts()
  end
end



