# frozen_string_literal: true

require 'optparse'

WIDTH = 3

def main
  file_lists = fetch_files(fetch_option)
  sliced_lists = sliced_file_lists(file_lists)
  show_result(sliced_lists)
end

def fetch_option
  option = {}
  opt = OptionParser.new
  opt.on('-a') { |a| option[:a] = a }
  opt.parse(ARGV)
  option
end

def fetch_files(option)
  if option[:a]
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
