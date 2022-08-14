# frozen_string_literal: true

WIDTH = 3

def main
  result(new_file_list)
end

def new_file_list
  file_name = Dir.glob('*')
  file_name = file_name.each_slice((file_name.size / WIDTH).ceil + 1).to_a
  max_size = file_name.map(&:size).max
  file_name.map { |it| it.values_at(0...max_size) }.transpose
end

def result(file_list)
  j = 0
  file_list.size.times do |i|
    while j < WIDTH
      print(file_list[i][j].to_s.ljust(15))
      j += 1
    end
    j = 0
    puts
  end
end

main
