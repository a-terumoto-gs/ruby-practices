#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def fetch_files
  invert_order = false

  OptionParser.new do |opts|
    opts.on('-r', 'invert_order') do
      invert_order = true
    end
  end.parse!

  if invert_order
    Dir.glob('*').reverse!
  else
    Dir.glob('*')
  end
end

def sort_files(files)
  elements_count = files.count
  columns_count = (elements_count % 3).zero? ? elements_count / 3 : elements_count / 3 + 1

  col1 = files.take(columns_count)
  case elements_count % 3
  when 1
    col2 = files.slice(columns_count, columns_count - 1)
    col3 = files.last(columns_count - 1)
  when 2
    col2 = files.slice(columns_count, columns_count)
    col3 = files.last(columns_count - 1)
  else
    col2 = files.slice(columns_count, columns_count)
    col3 = files.last(columns_count)
  end

  col2.push(' ') if elements_count % 3 == 1
  col3.push(' ') if elements_count % 3 == 1 || elements_count % 3 == 2

  [col1, col2, col3]
end

def display_files(files)
  max_length = files.flatten.map(&:length).max

  files.transpose.each do |index|
    puts index.map { |e| e.ljust(max_length) }.join(' ')
  end
end

sorted_files = sort_files(fetch_files)
display_files(sorted_files)
