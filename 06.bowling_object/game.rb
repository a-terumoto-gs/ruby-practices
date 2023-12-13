# frozen_string_literal: true

require_relative 'frame'
require_relative 'shot'

class Game
  def initialize(play_result)
    @frames = Frame.generate_frames(play_result)
  end

  def score
    game_score = @frames.map(&:score).sum
    @frames.each_with_index do |current_frame, index|
      break if index >= 9

      next_frame = @frames[index + 1]
      after_next_frame = @frames[index + 2]

      if current_frame.strike?
        game_score += strike_bonus(next_frame, after_next_frame)
      elsif current_frame.spare?
        game_score += spare_bonus(next_frame)
      else
        game_score
      end
    end
    game_score
  end

  def strike_bonus(next_frame, after_next_frame)
    if next_frame.strike?
      10 + after_next_frame.first_shot.score
    else
      next_frame.score
    end
  end

  def spare_bonus(next_frame)
    next_frame.first_shot.score
  end
end

game = Game.new(ARGV[0])
puts game.score
