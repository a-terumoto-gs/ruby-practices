#!/usr/bin/env ruby
# frozen_string_literal: true

def files_acquisition
  Dir.glob('*')
end

def files_sort
  number = files_acquisition.count
  row = (number % 3).zero? ? number / 3 : number / 3 + 1

  files = files_acquisition
  col1 = files[0, row]
  if number % 3 == 1
    col2 = files[row, row - 1]
    col3 = files[2 * row - 1, row - 1]
    col2.push(' ')
    col3.push(' ')
  elsif number % 3 == 2
    col2 = files[row, row]
    col3 = files[2 * row, row]
    col3.push(' ')
  else
    col2 = files[row, row]
    col3 = files[2 * row, row]
  end

  [col1, col2, col3].transpose.each do |index|
    puts index.map { |e| "#{e} " }.join(' ')
  end
end

files_sort
