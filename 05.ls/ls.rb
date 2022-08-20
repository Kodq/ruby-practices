# frozen_string_literal: true
require 'optparse'

WIDTH = 3

def main
  file_lists = fetch_file_list(fetch_option)
  sliced_lists = sliced_file_lists(file_lists)
  show_result(sliced_lists)
end

def fetch_option
  file_type = 0
  opt = OptionParser.new
  opt.on('-a', 'all') { file_type = 1 }
  opt.parse(ARGV)
  file_type
end

def fetch_file_list(file_type)
  if file_type == 1
    Dir.entries('.')
  else
    Dir.glob('*')
  end
end

def sliced_file_lists(file_lists)
  sliced_lists = file_lists.each_slice((file_lists.size / WIDTH.to_f).ceil).to_a
  max_size = sliced_lists.map(&:size).max
  sliced_lists.map { |it| it.values_at(0...max_size) }.transpose
end

def show_result(sliced_lists)
  sliced_lists.each do |list|
    puts(list.map { |name| name.to_s.ljust(15) }.join)
  end
end

main
