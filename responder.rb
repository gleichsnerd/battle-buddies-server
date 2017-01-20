class Responder

  def initialize(dt = 0.1)
    @can_return = false
    @dt = dt
  end

  def wait_and_return
    until @can_return do
      sleep @dt  
    end

    if block_given? 
      yield
    end
  end

  def allow_return
    @can_return = true
  end
end