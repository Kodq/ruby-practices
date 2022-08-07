score = ARGV[0]
scores = score.split(',')
$shots = []
$frames = []

def char_to_num (scores)
  scores.each do |s|
    if s == 'X'
      $shots << 10
      $shots << 0
    else
      $shots << s.to_i
    end
  end
end

def split_frames (shots)
  shots.each_slice(2) do |s|
    $frames << s
  end
end  


def sort_frames(frames)
  i = 0

  frames.each do
    if frames[i][0] == 10
      frames[i].pop
    end
    i += 1
  end

  if frames.size == 11
    frames[9].concat(frames.pop)
  elsif frames.size == 12
    2.times do 
      frames[9].concat(frames.pop)
    end
  end
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
      sum += frames[j].sum + frames[j+1][0]
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

char_to_num(scores)
split_frames($shots)
sort_frames($frames)
score_cal($frames)