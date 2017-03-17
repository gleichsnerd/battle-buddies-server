class GameObject

  attr_accessor :type, :events, :pos

  def initialize(type = :game_object)
    @type = type
    @events = Array.new
  end

  def add_event(event)
    @events << event
  end

  def to_h_public
    {
      :type => @type
    }
  end

  def to_h
    {
      :type => @type,
      :events => @events
    }
  end

end