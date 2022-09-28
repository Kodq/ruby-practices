# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'date'

WIDTH = 3
FILE = 6
PERMISSON_TYPE = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze
FILE_TYPE = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b', '10' => '-', '12' => 'l', '14' => 's' }.freeze
DIRECTORY_TYPE = { '1' => 'p', '2' => 'c', '4' => 'd', '6' => 'b' }.freeze

def main
  file_lists = fetch_files(fetch_option)

  file_lists = file_lists.reverse if fetch_option[:r]

  sliced_lists = sliced_file_lists(file_lists)

  if fetch_option[:l]
    show_detail(sliced_lists)
  else
    show_result(sliced_lists)
  end
end

def fetch_option
  option = {}
  opt = OptionParser.new
  opt.on('-l') { |l| option[:l] = l }
  opt.on('-r') { |r| option[:r] = r }
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

def show_detail(sliced_list)
  sliced_list.each do |list|
    list.each do |name|
      file_stats = File.stat(name)
      stats_lists = []

      stats_lists.push(get_mode(file_stats))
      stats_lists.push(file_stats.nlink)
      stats_lists.push(Etc.getpwuid(file_stats.uid).name)
      stats_lists.push(Etc.getgrgid(file_stats.gid).name)
      stats_lists.push(file_stats.size)
      stats_lists.push(file_stats.mtime.strftime('%m月%d %H:%M %Y'))
      stats_lists.push(name)

      show_lists = stats_lists.map { |stat| stat.to_s.ljust(5) }.join(' ')

      puts(show_lists)
    end
  end
end

def get_mode(file_stats)
  file_mode = file_stats.mode.to_s(8)
  split_mode = file_mode.split('')
  parsed_modes = []

  if split_mode.length == FILE
    parsed_modes.push(parse_file(split_mode))
  else
    parsed_modes.push(parse_directory(split_mode))
  end
  parsed_modes.push(parse_permisson(split_mode)).flatten.join
end

def parse_file(split_modes)
  FILE_TYPE[split_modes[0..1].join]
end

def parse_directory(split_modes)
  DIRECTORY_TYPE[split_modes[0]]
end

def parse_permisson(split_modes)
  split_modes.last(3).map { |mode| PERMISSON_TYPE[mode] }
end

main
