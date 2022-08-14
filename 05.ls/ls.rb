# frozen_string_literal: true

WIDTH = 3

def main
  result(new_file_lists)
end

def new_file_lists
  file_names = Dir.glob('*')
  file_names = file_names.each_slice((file_names.size / WIDTH.to_f).ceil).to_a
  max_size = file_names.map(&:size).max
  file_names.map { |it| it.values_at(0...max_size) }.transpose
end

def result(file_lists)
  j = 0
  file_lists.size.times do |i|
    while j < WIDTH
      print(file_lists[i][j].to_s.ljust(15))
      j += 1
    end
    j = 0
    puts
  end
end

main
