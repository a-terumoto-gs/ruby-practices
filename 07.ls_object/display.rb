#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'info_acquisition'

class Display
  def initialize
    @info_acquisition = InfoAcquisition.new
    @options = @info_acquisition.options
    @files = @info_acquisition.files
  end

  def sort_display_files(files)
    columns_count = 3
    max_length = files.map(&:length).max
    format_files = files.map { |file| file.ljust(max_length + 2) }
    format_files << nil while format_files.length % columns_count != 0

    rows = format_files.each_slice(format_files.length / columns_count).to_a
    rows.transpose.each do |row|
      puts row.join
    end
  end

  def display_files_detail(files)
    max_length = @info_acquisition.calculate_max_length(files)

    files.each do |file|
      file_set = []
      file_stat = File.stat(file)

      file_set.unshift(format("%-#{max_length[:filename_length]}s", file))
      file_set.unshift(format('%<month>2d月 %<day>2d %<time>2s',
                              month: File.mtime(file).month,
                              day: File.mtime(file).day,
                              time: File.mtime(file).strftime('%H:%M')))
      file_set.unshift(format("%#{max_length[:size_length]}s", File.size(file)))
      file_set.unshift(format("%-#{max_length[:group_length]}s", Etc.getgrgid(file_stat.gid).name))
      file_set.unshift(format("%-#{max_length[:owner_length]}s", Etc.getpwuid(file_stat.uid).name))
      file_set.unshift(format("%-#{max_length[:nlink_length]}s", file_stat.nlink))
      file_set.unshift(@info_acquisition.f_type_to_s(file_stat.mode) + @info_acquisition.f_perms_to_s(file_stat.mode))
      file_set_str = file_set.join(' ')
      puts file_set_str
    end
  end

  def execute_ls
    if @options[:detail_info]
      puts "合計 #{@info_acquisition.calculate_total_blocks(Dir.pwd) / 2}"
      display_files_detail(@files)
    else
      sort_display_files(@files)
    end
  end
end

display = Display.new
display.execute_ls
