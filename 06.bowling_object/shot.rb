# frozen_string_literal: true

class Shot
  attr_reader :shot

  def initialize(shot)
    @shot = shot
  end

  def strike_shot?
    if @shot.is_a?(String)
      @shot == 'X'
    elsif @shot.is_a?(Shot)
      @shot.shot == 'X'
    else
      false
    end
  end

  def score
    strike_shot? ? 10 : (@shot.nil? ? 0 : @shot&.shot.to_i)
  end
end
