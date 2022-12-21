# frozen_string_literal: true

require 'optparse'

def main
  file_names = fetch_name
  option = fetch_option
  pipe = File.pipe?($stdin)

  if option.empty?
    option[:lines] = true
    option[:words] = true
    option[:chars] = true
  end

  show_stats(file_names, option, pipe)
end

def fetch_name
  $stdin.readlines
end

def fetch_option
  option = {}
  opt = OptionParser.new
  opt.on('-l') { |l| option[:lines] = l }
  opt.on('-w') { |w| option[:words] = w }
  opt.on('-c') { |c| option[:chars] = c }
  opt.parse(ARGV)
  option
end

def show_stats(file_names, option, pipe)
  total_infos = { lines: 0, words: 0, bytes: 0 }
  select_option = option.select { |_k, v| v == true }
  input_contents = File.read(name)

  saves_info = []
  file_names.each do |name|
    file_infos = []
    name = name.chomp

    file_infos.push(show_lines(input_contents))
    file_infos.push(show_words(input_contents))
    file_infos.push(show_bytes(name, pipe))

    total_infos[:lines] = file_infos[0]
    total_infos[:words] = file_infos[1]
    total_infos[:chars] = file_infos[2]

    unless pipe
      select_option.each_key { |key| print("#{total_infos.values_at(key)[0]} ") }
      puts(name)
    end

    saves_info.push(file_infos)
  end

  show_sum(saves_info, pipe, option) if saves_info.size >= 2
end

def show_sum(saves_info, pipe, option)
  swap_infos = saves_info.transpose
  select_option = option.select { |_k, v| v == true }
  total_infos = { lines: 0, words: 0, chars: 0 }

  total_infos[:words] += swap_infos[1].sum
  total_infos[:chars] += swap_infos[2].sum

  if pipe
    total_infos[:lines] += swap_infos[0].size
    select_option.each_key { |key| print("#{total_infos.values_at(key)[0]} ") }
  else
    total_infos[:lines] += swap_infos[0].sum
    select_option.each_key { |key| print("#{total_infos.values_at(key)[0]} ") }
    print('Total')
  end
end

def show_lines(input_contents)
  input_contents.count("\n")
end

def show_words(inputs_contents)
  inputs_contents.split(' ').size
end

def show_bytes(file_name, pipe)
  if pipe
    file_name.bytesize
  else
    File.size(file_name)
  end
end

main
