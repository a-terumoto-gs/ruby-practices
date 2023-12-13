# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot

  def initialize(first_mark, second_mark)
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
  end

  def score
    @first_shot.score + @second_shot.score
  end

  def strike?
    @first_shot.strike_mark?
  end

  def spare?
    score == 10 && !strike?
  end

  def self.generate_frames(game)
    game_split = game.gsub(/X,/, 'X,0,').split(',')
    frames = []
    (0...game_split.length).step(2).each do |index|
      shot = game_split[index]
      next_shot = game_split[index + 1]
      frames << Frame.new(shot, next_shot)
    end
    frames
  end
end
