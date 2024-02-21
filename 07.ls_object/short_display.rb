# frozen_string_literal: true

class ShortDisplay
  def initialize(files)
    @files = files
  end

  def sort_files
    columns_count = 3
    max_length = @files.map(&:length).max
    format_files = @files.map { |file| file.ljust(max_length + 2) }
    format_files << nil while format_files.length % columns_count != 0

    rows = format_files.each_slice(format_files.length / columns_count).to_a
    rows.transpose.map(&:join).join("\n")
  end
end
