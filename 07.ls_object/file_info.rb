# frozen_string_literal: true

require 'time'

class FileInfo
  def initialize(file)
    @file = file
    @file_stat = File.stat(file)
  end

  def formatted_filename(max_length)
    format("%-#{max_length[:filename_length]}s", @file)
  end

  def formatted_date
    format('%<month>2d月 %<day>2d %<time>2s',
           month: @file_stat.mtime.month,
           day: @file_stat.mtime.day,
           time: @file_stat.mtime.strftime('%H:%M'))
  end

  def formatted_size(max_length)
    format("%#{max_length[:size_length]}s", @file_stat.size)
  end

  def formatted_group(max_length)
    format("%-#{max_length[:group_length]}s", Etc.getgrgid(@file_stat.gid).name)
  end

  def formatted_owner(max_length)
    format("%-#{max_length[:owner_length]}s", Etc.getpwuid(@file_stat.uid).name)
  end

  def formatted_nlink(max_length)
    format("%-#{max_length[:nlink_length]}s", @file_stat.nlink)
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
end
