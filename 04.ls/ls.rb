#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require 'time'

def determin_option
  detail_info = false

  OptionParser.new do |opts|
    opts.on('-l', 'detail_info') do
      detail_info = true
    end
  end.parse!

  detail_info
end

def fetch_files
    Dir.glob('*')
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

def f_type_to_s(mode)
  case mode & 0o170000
  when 0o100000
    '-'
  when 0o040000
    'd'
  when 0o120000
    'l'
  when 0o140000
    's'
  when 0o020000
    'c'
  when 0o060000
    'b'
  when 0o010000
    'p'
  else
    '?'
  end
end

def f_perms_to_s(mode)
  perms = ''
  # owner
  perms = mode & 0o400 != 0 ? "#{perms}r" : "#{perms}-"
  perms = mode & 0o200 != 0 ? "#{perms}w" : "#{perms}-"
  perms = mode & 0o100 != 0 ? "#{perms}x" : "#{perms}-"
  # group
  perms = mode & 0o040 != 0 ? "#{perms}r" : "#{perms}-"
  perms = mode & 0o020 != 0 ? "#{perms}w" : "#{perms}-"
  perms = mode & 0o010 != 0 ? "#{perms}x" : "#{perms}-"
  # others
  perms = mode & 0o004 != 0 ? "#{perms}r" : "#{perms}-"
  perms = mode & 0o002 != 0 ? "#{perms}w" : "#{perms}-"
  perms = mode & 0o001 != 0 ? "#{perms}x" : "#{perms}-"
end

def fetch_sort_files_detail(files)
  max_filename_length = files.max_by(&:length).length
  max_size_length = files.map { |file| File.size(file).to_s.length }.max
  max_group_length = files.map { |file| Etc.getgrgid(File.stat(file).gid).name.length }.max
  max_owner_length = files.map { |file| Etc.getpwuid(File.stat(file).uid).name.length }.max
  max_nlink_length = files.map { |file| File.stat(file).nlink.to_s.length }.max

  files.each do |file|
    box = []
    file_stat = File.stat(file)

    box.unshift(format("%-#{max_filename_length}s", file))
    box.unshift(format('%<month>2d月 %<day>2d %<time>2s', month: File.mtime(file).month, day: File.mtime(file).day, time: File.mtime(file).strftime('%H:%M')))
    box.unshift(format("%#{max_size_length}s", File.size(file)))
    box.unshift(format("%-#{max_group_length}s", Etc.getgrgid(file_stat.gid).name))
    box.unshift(format("%-#{max_owner_length}s", Etc.getpwuid(file_stat.uid).name))
    box.unshift(format("%-#{max_nlink_length}s", file_stat.nlink))
    box.unshift(f_type_to_s(file_stat.mode) + f_perms_to_s(file_stat.mode))
    box_str = box.join(' ')
    puts box_str
  end
end

def display_list_files
  detail_info = determin_option
  if detail_info
    sorted_files = fetch_sort_files_detail(fetch_files)
  else 
    sorted_files = sort_files(fetch_files)
    display_files(sorted_files)
  end
end

display_list_files
