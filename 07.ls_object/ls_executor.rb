#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'l_option_handler'
require_relative 'default_option_handler'

class LsExecutor
  def initialize
    @loptionhandler = LOptionHandler.new
    @defaultoptionhandler= DefaultOptionHandler.new
  end

  def determine_option
    options = { detail_info: false, include_hidden_files: false, invert_order: false }

    OptionParser.new do |opts|
      opts.on('-l', 'detail_info') do
        options[:detail_info] = true
      end

      opts.on('-a', 'Include hidden files') do
        options[:include_hidden_files] = true
      end

      opts.on('-r', 'invert_order') do
        options[:invert_order] = true
      end
    end.parse!

    options
  end

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

  def execute_ls
    options = determine_option
    if options[:detail_info]
      puts "合計 #{@loptionhandler.calculate_total_blocks(Dir.pwd) / 2}"
      @loptionhandler.fetch_display_files_detail(fetch_files(options))
    else
      @defaultoptionhandler.display_files(@defaultoptionhandler.sort_files(fetch_files(options)))
    end
  end

end

ls_execution = LsExecutor.new
ls_execution.execute_ls
