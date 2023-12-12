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

  def self.allocation_play_result(play_result)
    play_result_split = play_result.split(',')
    frames = []
    index = 0
    while index < play_result.length
      shot = play_result_split[index]
      if Shot.new(shot).strike_mark?
        frames << Frame.new(shot, '0')
        index += 1
      else
        next_shot = play_result_split[index + 1] || '0'
        frames << Frame.new(shot, next_shot)
        index += 2
      end
    end
    
    frames
  end
end
