#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'display'
require_relative 'file_info'

class LsExecutor
  def initialize
    @display = Display.new
    @file_info = FileInfo.new
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

  def execute_ls
    options = determine_option
    if options[:detail_info]
      puts "合計 #{@file_info.calculate_total_blocks(Dir.pwd) / 2}"
      @display.display_files_detail(@file_info.fetch_files(options))
    else
      @display.display_files(@display.sort_files(@file_info.fetch_files(options)))
    end
  end
end

ls_executor = LsExecutor.new
ls_executor.execute_ls
