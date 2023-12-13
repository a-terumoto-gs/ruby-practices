# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_mark, second_mark, third_mark = nil)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    @first_shot.score + @second_shot.score + @third_shot.score
  end

  def strike?
    @first_shot.strike_mark?
  end

  def spare?
    score == 10 && !strike?
  end

  def self.game_result_adjustment(game)
    game_split = []
    game.split(',').each do |mark|
      if game_split.length < 18
        if Shot.new(mark).strike_mark?
          game_split << 'X' << '0'
        else
          game_split << mark
        end
      else
        game_split << mark
      end
    end
    game_split
  end

  def self.generate_frames(game)
    game_split = game_result_adjustment(game)

    frames = []
    (0...18).step(2).each do |index|
      shot = game_split[index]
      next_shot = game_split[index + 1]
      frames << Frame.new(shot, next_shot)
    end

    frames << if game_split.length == 20
                Frame.new(game_split[-2], game_split[-1])
              else
                Frame.new(game_split[-3], game_split[-2], game_split[-1])
              end
  end
end
