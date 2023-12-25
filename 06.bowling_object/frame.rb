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

  def self.marks_adjustment(marks)
    shots = marks.split(',')
    splitted_shots = []
    shots.each do |shot|
      if splitted_shots.length < 18
        current_shot = Shot.new(shot)
        if current_shot.strike_mark?
          splitted_shots << 'X' << '0'
        else
          splitted_shots << shot
        end
      else
        splitted_shots << shot
      end
    end
    splitted_shots
  end

  def self.generate_frames(marks)
    splitted_shots = marks_adjustment(marks)

    frames = []
    (0...18).step(2).each do |index|
      shot = splitted_shots[index]
      next_shot = splitted_shots[index + 1]
      frames << Frame.new(shot, next_shot)
    end

    frames << if splitted_shots.length == 20
                Frame.new(splitted_shots[-2], splitted_shots[-1])
              else
                Frame.new(splitted_shots[-3], splitted_shots[-2], splitted_shots[-1])
              end
  end
end
