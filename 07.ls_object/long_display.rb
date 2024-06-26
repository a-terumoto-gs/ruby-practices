# frozen_string_literal: true

require 'etc'
require_relative 'file_info'

class LongDisplay
  def initialize(files)
    @files = files
  end

  def calculate_total_blocks(directory_path)
    total_blocks = 0

    Dir.foreach(directory_path) do |entry|
      next if ['.', '..'].include?(entry)

      entry_path = File.join(directory_path, entry)

      if File.file?(entry_path)
        file_stat = File.stat(entry_path)
        total_blocks += file_stat.blocks
      elsif File.directory?(entry_path)
        total_blocks += calculate_total_blocks(entry_path)
      end
    end
    total_blocks
  end

  def calculate_max_length
    max_length = { filename_length: 0, size_length: 0, group_length: 0, owner_length: 0, nlink_length: 0 }
    max_length[:filename_length] = @files.max_by(&:length).length
    max_length[:size_length] = @files.map { |file| File.size(file).to_s.length }.max
    max_length[:group_length] = @files.map { |file| Etc.getgrgid(File.stat(file).gid).name.length }.max
    max_length[:owner_length] = @files.map { |file| Etc.getpwuid(File.stat(file).uid).name.length }.max
    max_length[:nlink_length] = @files.map { |file| File.stat(file).nlink.to_s.length }.max

    max_length
  end

  def sort_files
    max_length = calculate_max_length
    display_sets = []
    display_sets << "合計 #{calculate_total_blocks(Dir.pwd) / 2}"

    file_sets = []
    @files.each do |file|
      file_info = FileInfo.new(file)
      file_set = [
        file_info.f_type_to_s + file_info.f_perms_to_s,
        file_info.formatted_nlink(max_length),
        file_info.formatted_owner(max_length),
        file_info.formatted_group(max_length),
        file_info.formatted_size(max_length),
        file_info.formatted_date,
        file_info.formatted_filename(max_length)
      ].join(' ')
      file_sets << file_set
    end
    display_sets << file_sets
  end
end
