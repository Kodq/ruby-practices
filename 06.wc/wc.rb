# frozen_string_literal: true

require 'optparse'

def main
  file_names = fetch_name
  option = fetch_option

  if FileTest.exist?(file_names.first.chomp)
    show_file_stats(file_names, fetch_option)
  else
    show_stats(file_names, option)
  end
end

def fetch_name
  $stdin.readlines
end

def fetch_option
  option = {}
  opt = OptionParser.new
  opt.on('-l') { |l| option[:l] = l }
  opt.on('-w') { |w| option[:w] = w }
  opt.on('-c') { |c| option[:c] = c }
  opt.parse(ARGV)
  option
end

def show_stats(file_names, option)
  file_info = []

  if option.empty?
    option[:l] = true
    option[:w] = true
    option[:c] = true
  end

  file_info.push(show_lines(file_names)) if option[:l]
  file_info.push(show_words(file_names)) if option[:w]
  file_info.push(show_bytes(file_names)) if option[:c]
  puts(file_info.join(' '))
end

def show_file_stats(file_names, option)
  file_info = []
  save_info = []

  if option.empty?
    option[:l] = true
    option[:w] = true
    option[:c] = true
  end

  file_names.each do |name|
    file_info = []
    name = name.chomp
    file_info.push(show_file_lines(name)) if option[:l]
    file_info.push(show_file_words(name)) if option[:w]
    file_info.push(show_file_bytes(name)) if option[:c]
    file_info.push(name)
    save_info.push(file_info) if file_names.size >= 2
    puts(file_info.join(' '))
  end
  show_sum(save_info) if file_names.size >= 2
end

def show_sum(save_info)
  swap_info = save_info.transpose
  swap_info.pop
  sum_info = swap_info.map(&:sum)
  print("#{sum_info.join(' ')} Total")
end

def show_lines(file_names)
  file_names.size
end

def show_words(file_names)
  word_count = []
  file_names.each { |name| word_count.push(name.split(' ')) }
  word_count.flatten.size
end

def show_bytes(file_names)
  byte_list = []
  file_names.each { |name| byte_list.push(name.bytesize) }
  byte_list.sum
end

def show_file_lines(file_name)
  File.read(file_name).count("\n")
end

def show_file_words(file_name)
  File.read(file_name).split(' ').size
end

def show_file_bytes(file_name)
  File.size(file_name)
end

main
