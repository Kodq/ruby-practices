# frozen_string_literal: true

require 'optparse'

def main
  option = fetch_option

  argv_lists = ARGV

  input_names = if argv_lists.empty?
                  $stdin.readlines
                elsif File.exist?(argv_lists.first)
                  fetch_file(option)
                end

  if option.values.none?
    option[:lines] = true
    option[:words] = true
    option[:chars] = true
  end

  show_stats(input_names, option, argv_lists)
end

def show_stats(input_names, option, argv_lists)
  total_infos = { lines: 0, words: 0, chars: 0 }
  select_option = option.select { |_k, v| v }

  saves_info = []

  input_names.each do |name|
    file_infos = []

    input_contents = argv_or_input(name, argv_lists)

    file_infos.push(show_lines(input_contents))
    file_infos.push(show_words(input_contents))
    file_infos.push(show_bytes(name, argv_lists))

    total_infos[:lines] = file_infos[0]
    total_infos[:words] = file_infos[1]
    total_infos[:chars] = file_infos[2]

    unless argv_lists.empty?
      select_option.each_key { |k| print("#{total_infos.values_at(k)[0]} ") }
      puts(name)
    end

    saves_info.push(file_infos)
  end

  show_sum(saves_info, argv_lists, option) if (saves_info.size >= 2) || argv_lists.empty?
end

def show_sum(save_infos, argv_lists, option)
  swap_infos = save_infos.transpose
  select_option = option.select { |_k, v| v }
  total_infos = { lines: 0, words: 0, chars: 0 }

  total_infos[:words] += swap_infos[1].sum
  total_infos[:chars] += swap_infos[2].sum
  total_infos[:lines] += argv_lists.empty? ? swap_infos[0].size : swap_infos[0].sum

  select_option.each_key { |key| print("#{total_infos.values_at(key)[0]} ") }
  print 'Total' unless argv_lists.empty?
end

def argv_or_input(name, argv_lists)
  if argv_lists.empty?
    input_contents = name
  else
    name = name.chomp
    input_contents = File.read(name)
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

  ARGV.pop if option.values.any?

  option
end

def show_lines(input_contents)
  input_contents.count("\n")
end

def show_words(inputs_contents)
  inputs_contents.split(' ').size
end

def show_bytes(name, argv_lists)
  if argv_lists.empty?
    name.bytesize
  else
    File.size(name)
  end
end

main
