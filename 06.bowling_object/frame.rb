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

  def self.marks_adjustment(marks)
    shots = marks.split(',').map { |mark| Shot.new(mark) }
    splitted_shots = []
    shots.each do |current_shot|
      if splitted_shots.length < 18
        if current_shot.strike_shot?
          splitted_shots.concat([Shot.new('X'), Shot.new('0')])
        else
          splitted_shots << current_shot
        end
      else
        splitted_shots << current_shot
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
