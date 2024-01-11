# frozen_string_literal: true

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(first_shot, second_shot, third_shot = nil)
    @first_shot = Shot.new(first_shot)
    @second_shot = Shot.new(second_shot)
    @third_shot = Shot.new(third_shot)
  end

  def score
    @first_shot.score + @second_shot.score + @third_shot.score
  end

  def strike?
    @first_shot.strike_shot?
  end

  def spare?
    score == 10 && !strike?
  end

  def self.generate_frames(marks)
    shots = marks.split(',').map { |mark| Shot.new(mark) }
    frames = []

    9.times do
      shot = shots.shift
      if shot.strike_shot?
        frames << Frame.new(shot, Shot.new('0'))
      else
        next_shot = shots.shift
        frames << Frame.new(shot, next_shot)
      end
    end
    frames << Frame.new(*shots)
  end
end
