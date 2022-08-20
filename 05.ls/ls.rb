# frozen_string_literal: true

WIDTH = 3

def main
  show_result(make_file_lists)
end

def make_file_lists
  file_names = Dir.glob('*')
  file_names = file_names.each_slice((file_names.size / WIDTH.to_f).ceil).to_a
  max_size = file_names.map(&:size).max
  file_names.map { |it| it.values_at(0...max_size) }.transpose
end

def show_result(file_lists)
  file_lists.each do |list|
    puts(list.map { |name| name.to_s.ljust(15) }.join)
  end
end

main
