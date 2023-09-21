#!/usr/bin/env ruby
# frozen_string_literal: true

def sort_display
  col1, col2, col3 = files_sort
  files_display(col1, col2, col3)
end

def files_sort
  files = Dir.glob('*')
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

def files_display(col1, col2, col3)
  max_length = [col1, col2, col3].map { |col| col.max_by(&:length).length }.max

  [col1, col2, col3].transpose.each do |index|
    puts index.map { |e| e.ljust(max_length) }.join(' ')
  end
end

sort_display
