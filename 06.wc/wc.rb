# frozen_string_literal: true

require 'optparse'

def main
  option = fetch_option
  inputs = $stdin.readlines

  input_names = if inputs.empty?
                  fetch_file(option)
                else
                  inputs
                end

  if option.values.none?
    option[:lines] = true
    option[:words] = true
    option[:chars] = true
  end

  show_stats(input_names, inputs, option)
end

def show_stats(input_names, inputs, option)
  total_infos = { lines: 0, words: 0, chars: 0 }
  select_option = option.select { |_k, v| v }

  saves_info = []

  input_names.each do |name|
    file_infos = []

    input_contents = argv_of_input(name, inputs)

    file_infos.push(show_lines(input_contents))
    file_infos.push(show_words(input_contents))
    file_infos.push(show_bytes(name, inputs))

    total_infos[:lines] = file_infos[0]
    total_infos[:words] = file_infos[1]
    total_infos[:chars] = file_infos[2]

    if inputs.empty?
      select_option.each_key { |k| print("#{total_infos.values_at(k)[0]} ") }
      puts(name)
    end

    saves_info.push(file_infos)
  end

  show_sum(saves_info, inputs, option) if saves_info.size >= 2
end

def show_sum(saves_info, inputs, option)
  swap_infos = saves_info.transpose
  select_option = option.select { |_k, v| v }
  total_infos = { lines: 0, words: 0, chars: 0 }

  total_infos[:words] += swap_infos[1].sum
  total_infos[:chars] += swap_infos[2].sum
  total_infos[:lines] += inputs.empty? ? swap_infos[0].sum : swap_infos[0].size
  select_option.each_key { |key| print("#{total_infos.values_at(key)[0]} ") }
  print 'Total' if inputs.empty?
end

def fetch_file(option)
  file_names = ARGV
  file_names.pop if option.values.any?
  file_names
end

def argv_of_input(name, inputs)
  if inputs.empty?
    name = name.chomp
    input_contents = File.read(name)
  else
    input_contents = name
  end
  input_contents
end

def fetch_option
  option = { lines: false, words: false, chars: false }
  opt = OptionParser.new
  opt.on('-l') { |l| option[:lines] = l }
  opt.on('-w') { |w| option[:words] = w }
  opt.on('-c') { |c| option[:chars] = c }
  opt.parse(ARGV)

  option
end

def show_lines(input_contents)
  input_contents.count("\n")
end

def show_words(inputs_contents)
  inputs_contents.split(' ').size
end

def show_bytes(name, inputs)
  if inputs.empty?
    File.size(name)
  else
    name.bytesize
  end
end

main
