require './bb_object'

class GameObject < BBObject

  attr_accessor :type, :events, :pos

  def initialize(type = :game_object)
    @type = type
    @events = Array.new
  end

  def add_event(event)
    @events << event
  end

  def append_event(event)
    if @events.length > 0
      last_event = @events.pop
      event = last_event + " #{event}"
    end

    @events.push(event)
  end

  def to_h_public
    super
  end

  def to_h
    h = super
    additional_fields = {
      :events => @events
    }

    h.merge(additional_fields)
  end

end