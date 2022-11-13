# frozen_string_literal: true

require 'optparse'

def main
  file_names = fetch_name
  option = fetch_option

  if option.empty?
    option[:l] = true
    option[:w] = true
    option[:c] = true
  end

  exist_file = FileTest.exist?(file_names.first.chomp)
  show_stats(file_names, option, exist_file)
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

def show_stats(file_names, option, exist_file)
  save_info = []

  file_names.each do |name|
    file_info = []
    name = name.chomp
    file_info.push(show_lines(name, exist_file)) if option[:l]
    file_info.push(show_words(name, exist_file)) if option[:w]
    file_info.push(show_bytes(name, exist_file)) if option[:c]

    if exist_file
      file_info.push(name)
      puts(file_info.join(' '))
    end

    save_info.push(file_info)
  end

  show_sum(save_info, exist_file, option)
end

def show_sum(save_info, exist_file, option)
  swap_info = save_info.transpose

  if save_info.size >= 2 && exist_file
    swap_info.pop
    sum_info = swap_info.map(&:sum)
    puts("#{sum_info.join(' ')} Total")
  end

  return if exist_file

  sum_info = []

  sum_info.push(swap_info[0].size) if option[:l]
  sum_info.push(swap_info[1].sum) if option[:w]
  sum_info.push(swap_info[2].sum) if option[:c]

  puts(sum_info.join(' '))
end

def show_lines(file_name, exist_file)
  if exist_file
    File.read(file_name).count("\n")
  else
    file_name.size
  end
end

def show_words(file_name, exist_file)
  if exist_file
    File.read(file_name).split(' ').size
  else
    word_count = []
    word_count.push(file_name.split(' '))
    word_count.flatten.size
  end
end

def show_bytes(file_name, exist_file)
  if exist_file
    File.size(file_name)
  else
    file_name.bytesize
  end
end

main
