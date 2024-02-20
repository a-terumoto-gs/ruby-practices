#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'essential_info'
require_relative 'long_display'
require_relative 'short_display'

class Ls
  def initialize
    @essential_info = EssentialInfo.new
    @files =  @essential_info.files
    @options = @essential_info.options

    @display = if @options[:detail_info]
                 LongDisplay.new(@files)
               else
                 ShortDisplay.new(@files)
               end
  end

  def run_command
    puts "合計 #{@display.calculate_total_blocks(Dir.pwd) / 2}" if @options[:detail_info]
    @display.display_files
  end
end

ls = Ls.new
ls.run_command
