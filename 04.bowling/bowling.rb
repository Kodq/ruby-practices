# frozen_string_literal: true

def main
  score = ARGV[0]
  scores = score.split(',')

  shots = make_shots(scores)
  frames = split_frames(shots)
  show_score(frames)
end

def make_shots(scores)
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
  all_shots = frames.flatten
  frame_scores =
    frames.map.with_index do |shots, i|
      if i == 9
        shots.sum
      elsif shots[0] == 10
        shot_count = frames[0..i].map(&:size).sum
        shots.sum + all_shots[shot_count] + all_shots[shot_count + 1]
      elsif shots.sum == 10
        shots.sum + frames[i + 1][0]
      else
        shots.sum
      end
    end
  puts(frame_scores.sum)
end

main
