# frozen_string_literal: true

require 'optparse'

class EssentialInfo
  attr_reader :options, :files

  def initialize
    @options = determine_option
    @files = fetch_files
  end

  private

  def determine_option
    options = { detail_info: false, include_hidden_files: false, invert_order: false }

    OptionParser.new do |opts|
      opts.on('-l', 'detail_info') do
        options[:detail_info] = true
      end

      opts.on('-a', 'include hidden files') do
        options[:include_hidden_files] = true
      end

      opts.on('-r', 'invert_order') do
        options[:invert_order] = true
      end
    end.parse!

    options
  end

  def fetch_files
    files = if @options[:include_hidden_files]
              Dir.glob('*', File::FNM_DOTMATCH)
            else
              Dir.glob('*')
            end

      files.reverse! if @options[:invert_order]
      files
  end
end
