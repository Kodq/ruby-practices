# frozen_string_literal: true

def main
  score = ARGV[0]
  scores = score.split(',')

  shots = char_to_num(scores)
  frames = sort_frames(split_frames(shots))
  score_cal(frames)
end

def char_to_num(scores)
  shots = []
  scores.each do |s|
    if s == 'X'
      shots << 10
      shots << 0
    else
      shots << s.to_i
    end
  end
  shots
end

def split_frames(shots)
  frames = []
  shots.each_slice(2) do |s|
    frames << s
  end
  frames
end

def sort_frames(frames)
  i = 0

  frames.each do
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
  frames
end

def score_cal(frames)
  j = 0
  sum = 0
  num = 0

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
end

main
