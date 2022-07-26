# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
shots = []
frames = []
i = 0
j = 0
num = 0
sum = 0
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

shots.each_slice(2) do |s|
  frames << s
end

frames.each do |_s|
  frames[i].pop if frames[i][0] == 10
  i += 1
end

case frames.size
when 11
  frames[9].concat(frames.pop)
when 12
  2.times do
    frames[9].concat(frames.pop)
  end
end

while j <= 8
  if frames[j][0] == 10
    sum += frames.flatten[num] + frames.flatten[num + 1] + frames.flatten[num + 2]
    num += 1
  elsif frames[j].sum == 10
    sum += frames[j].sum + frames[j + 1][0]
    num += 2
  else
    sum += frames[j].sum
    num += 2
  end
  j += 1
end

sum += frames[j].sum

puts sum
