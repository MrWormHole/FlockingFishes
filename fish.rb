require "./vector2d.rb"
$population = 0

class Fish
  attr_accessor :pos_vec,:vel_vec,:acc_vec
  @@images = Array[Gosu::Image.new("img/blue_fish.png", :tileable => true),
                   Gosu::Image.new("img/yellow_fish.png", :tileable => true),
                   Gosu::Image.new("img/red_fish.png", :tileable => true)]
  @@MAX_FORCE = 0.2
  @@MAX_SPEED = 4
  def initialize()
    @image = @@images[rand(3)]
    @pos_vec = Vector2.new(rand()*800,rand()*600)
    @vel_vec = Vector2.new((10*rand()-5)/100,(10*rand()-5)/100)
    @vel_vec.magnitude = 4
    @acc_vec = Vector2.new((10* rand()-5)/1000,(10*rand()-5)/1000)
    $population += 1
  end

  def update()
    mirror()
    @pos_vec = @pos_vec + @vel_vec
    @vel_vec = @vel_vec + @acc_vec
  end

  def draw()
    @image.draw(@pos_vec.x, @pos_vec.y, 0, scale_x = 0.35 , scale_y = 0.35)
  end

  def mirror()
    if @pos_vec.x > 800
      @pos_vec.x = 0
    elsif @pos_vec.x < 0
      @pos_vec.x = 800
    end
    if @pos_vec.y > 600
      @pos_vec.y = 0
    elsif @pos_vec.y < 0
      @pos_vec.y = 600
    end
  end

  def align(fishes)
    perceptionRadius = 50
    steeringForce = Vector2.new(0,0)
    fishesAround = 0
    fishes.each do |other|
      distance = self.pos_vec.distance(other.pos_vec)
      if other != self and distance < perceptionRadius
        steeringForce = steeringForce + other.vel_vec
        fishesAround += 1
      end
    end
    if fishesAround > 0
      steeringForce = steeringForce.set!(steeringForce.x / fishesAround ,steeringForce.y / fishesAround)
      steeringForce.magnitude = @@MAX_SPEED
      steeringForce = steeringForce - self.vel_vec
      if steeringForce.magnitude > @@MAX_FORCE
        steeringForce.magnitude = @@MAX_FORCE
      end
    end
    return steeringForce
  end

  def flock(fishes)
    alignment = align(fishes)
    @acc_vec = alignment
  end

  def getPopulation()
    return $population
  end
end