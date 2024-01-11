# frozen_string_literal: true

class Display
  def initialize
    @file_info = FileInfo.new
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

  def display_files_detail(files)
    max_length = @file_info.calculate_max_length(files)

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
      file_set.unshift(@file_info.f_type_to_s(file_stat.mode) + @file_info.f_perms_to_s(file_stat.mode))
      file_set_str = file_set.join(' ')
      puts file_set_str
    end
  end
end
