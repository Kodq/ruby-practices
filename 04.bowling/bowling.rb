# frozen_string_literal: true

def main
  score = ARGV[0]
  scores = score.split(',')

  shots = to_number(scores)
  frames = split_frames(shots)
  show_score(frames)
end

def to_number(scores)
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
  sliced_shots = shots.each_slice(2).to_a

  sliced_shots.each do |frames|
    frames.pop if frames[0] == 10
  end
  sliced_shots[0..8] + [sliced_shots[9..].flatten]
end

def show_score(frames)
  sum = 0

  frames[0..8].each_with_index do |point, i|
    if point[0] == 10
      flat_frames = frames.flatten
      throw_frames = frames[0..i].map(&:size).sum
      sum += point.sum + flat_frames[throw_frames] + flat_frames[throw_frames + 1]
    elsif point.sum == 10
      sum += point.sum + frames[i + 1][0]
    else
      sum += point.sum
    end
  end

  puts sum += frames[9].sum
end

main
