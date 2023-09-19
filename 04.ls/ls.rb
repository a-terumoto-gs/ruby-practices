#!/usr/bin/env ruby
# frozen_string_literal: true

require 'debug'

def fetched_files
  Dir.glob('*')
end

def files_sort_display
  files = fetched_files
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

  [col1, col2, col3].transpose.each do |index|
    puts index.map { |e| "#{e} " }.join(' ')
  end
end

files_sort_display
