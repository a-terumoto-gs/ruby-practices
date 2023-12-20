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
    splitted_marks = []
    marks.split(',').each do |mark|
      if splitted_marks.length < 18
        shot = Shot.new(mark)
        if Shot.new(mark).strike_mark?
          splitted_marks << 'X' << '0'
        else
          splitted_marks << mark
        end
      else
        splitted_marks << mark
      end
    end
    splitted_marks
  end

  def self.generate_frames(marks)
    splitted_marks = marks_adjustment(marks)

    frames = []
    (0...18).step(2).each do |index|
      mark = splitted_marks[index]
      next_mark = splitted_marks[index + 1]
      frames << Frame.new(mark, next_mark)
    end

    frames << if splitted_marks.length == 20
                Frame.new(splitted_marks[-2], splitted_marks[-1])
              else
                Frame.new(splitted_marks[-3], splitted_marks[-2], splitted_marks[-1])
              end
  end
end
