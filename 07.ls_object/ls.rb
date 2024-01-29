#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'essential_info'
require_relative 'long_display'
require_relative 'short_display'

class Ls
  def initialize
    @essential_info = EssentialInfo.new
    @options = @essential_info.options

    if @options[:detail_info]
      @display = LongDisplay.new(@essential_info)
    else
      @display = ShortDisplay.new(@essential_info)
    end
  end

  def run_command
      puts "合計 #{@display.calculate_total_blocks(Dir.pwd) / 2}" if @options[:detail_info]
      @display.display_files(@essential_info.files) 
  end
end

ls = Ls.new
ls.run_command
