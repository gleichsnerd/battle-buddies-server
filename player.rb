require 'securerandom'

class Player

  attr_accessor :id

  def initialize
    @id=SecureRandom.uuid
  end

  def to_h
    {
      :type => "player",
      :id => @id
    }
  end

end