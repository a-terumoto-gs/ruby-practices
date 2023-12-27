# frozen_string_literal: true

class Shot
  def initialize(shot)
    @shot = shot
  end

  def strike_shot?
    @shot == 'X'
  end

  def score
    strike_shot? ? 10 : @shot.score
  end
end
