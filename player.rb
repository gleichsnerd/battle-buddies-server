require 'securerandom'

class Player

  attr_accessor :id

  def initialize
    @id=SecureRandom.uuid
  end

  

end