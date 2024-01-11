# frozen_string_literal: true

require 'etc'
require 'time'
require_relative 'file_info'

class FileInfo
  def fetch_files(options)
    files = if options[:include_hidden_files]
              Dir.glob('*', File::FNM_DOTMATCH)
            else
              Dir.glob('*')
            end

    if options[:invert_order]
      files.reverse!
    else
      files
    end
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
    owner_perms = format_perms(mode, 6)
    group_perms = format_perms(mode, 3)
    other_perms = format_perms(mode, 0)

    "#{owner_perms}#{group_perms}#{other_perms}"
  end

  def format_perms(mode, shift)
    perms = +''
    perms << (mode & (0o400 >> shift) != 0 ? 'r' : '-')
    perms << (mode & (0o200 >> shift) != 0 ? 'w' : '-')
    perms << (mode & (0o100 >> shift) != 0 ? 'x' : '-')
    perms
  end

  def calculate_max_length(files)
    max_length = { filename_length: 0, size_length: 0, group_length: 0, owner_length: 0, nlink_length: 0 }
    max_length[:filename_length] = files.max_by(&:length).length
    max_length[:size_length] = files.map { |file| File.size(file).to_s.length }.max
    max_length[:group_length] = files.map { |file| Etc.getgrgid(File.stat(file).gid).name.length }.max
    max_length[:owner_length] = files.map { |file| Etc.getpwuid(File.stat(file).uid).name.length }.max
    max_length[:nlink_length] = files.map { |file| File.stat(file).nlink.to_s.length }.max

    max_length
  end
end
