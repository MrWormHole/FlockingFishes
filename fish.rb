$population = 0
class Fish

  @@images = Array[Gosu::Image.new("img/blue_fish.png", :tileable => true),
                   Gosu::Image.new("img/yellow_fish.png", :tileable => true),
                   Gosu::Image.new("img/red_fish.png", :tileable => true)]
  def initialize()

    @image = @@images[rand(3)]
    @x = @y = @velocityX = @velocityY = @accX = @accY = @rot = 0
    #position vector , velocity vector and acc vector
    $population += 1
    warp(rand(640),rand(480))
  end

  def warp(x,y)
    # randomNum = (b-a)* rand() + a this generates between a and b
    # we have used as a = -10 and b = 8
    #
    @x,@y = x,y
    @velocityX = 18 * rand() - 10
    @velocityY = 18 * rand() - 10
  end

  def update()
    @x += @velocityX
    @y += @velocityY
    @velocityX += @accX
    @velocityY += @accY
    if @x<0 or @x>640 and @y<0 or @y>480
      #@x = 320
      #@y = 240
    end
  end

  def draw()
    @image.draw(@x, @y, 0, scale_x = 0.35 , scale_y = 0.35)
  end

  def getPopulation()
    return $population
  end
end