require "./vector2.rb"
$population = 0

class Fish
  attr_reader :pos_vec,:vel_vec,:acc_vec,:angle
  @@images = Array[Gosu::Image.new("img/blue_fish.png"),
                   Gosu::Image.new("img/yellow_fish.png"),
                   Gosu::Image.new("img/red_fish.png")]
  @@MAX_FORCE = 0.2
  @@MAX_SPEED = 4
  def initialize
    @image = @@images[rand(3)]
    @pos_vec = Vector2.new(rand()*800,rand()*600)
    @vel_vec = Vector2.new((10*rand()-5)/100,(10*rand()-5)/100)
    @vel_vec.magnitude = 4
    @acc_vec = Vector2.new((10* rand()-5)/1000,(10*rand()-5)/1000)
    @angle = 0
    @last_angle = 0
    $population += 1
  end

  def update
    mirror
    @pos_vec = @pos_vec + @vel_vec
    @vel_vec = @vel_vec + @acc_vec
    #puts "vel_vec angle: #{vel_vec.angle_deg} | pos_vec angle: #{pos_vec.angle_deg} | #{@angle}"
    #rotate()
    @vel_vec.limit(@@MAX_SPEED)
    @acc_vec = @acc_vec * 0
  end

  def rotate
    if @angle < @vel_vec.angle_deg + 180 and vel_vec.angle_deg < 0
      @angle += 4
    elsif @angle > @vel_vec.angle_deg - 180 and vel_vec.angle_deg > 0
      @angle -= 4
    end
  end

  def draw
    @image.draw_rot(@pos_vec.x, @pos_vec.y, 0, @angle ,0.5,0.5,0.35 ,0.35)
  end

  def mirror
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
    perceptionRadius = 80
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

  def cohesion(fishes)
    perceptionRadius = 60
    steeringForce = Vector2.new(0,0)
    fishesAround = 0
    fishes.each do |other|
      distance = self.pos_vec.distance(other.pos_vec)
      if other != self and distance < perceptionRadius
        steeringForce = steeringForce + other.pos_vec
        fishesAround += 1
      end
    end
    if fishesAround > 0
      steeringForce = steeringForce.set!(steeringForce.x / fishesAround ,steeringForce.y / fishesAround)
      steeringForce = steeringForce - self.pos_vec
      steeringForce.magnitude = @@MAX_SPEED
      steeringForce = steeringForce - self.vel_vec
      if steeringForce.magnitude > @@MAX_FORCE
        steeringForce.magnitude = @@MAX_FORCE
      end
    end
    return steeringForce
  end

  def separation(fishes)
    perceptionRadius = 100
    steeringForce = Vector2.new(0,0)
    fishesAround = 0
    fishes.each do |other|
      distance = self.pos_vec.distance(other.pos_vec)
      if other != self and distance < perceptionRadius
        diff = Vector2.new((self.pos_vec - other.pos_vec).x,(self.pos_vec - other.pos_vec).y)
        diff = diff * (1/distance)
        steeringForce = steeringForce + diff
        fishesAround += 1
      end
    end
    if fishesAround > 0
      steeringForce = steeringForce.set!(steeringForce.x / fishesAround ,steeringForce.y / fishesAround)
      #steeringForce = steeringForce - self.pos_vec
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
    cohesion = cohesion(fishes)
    separation = separation(fishes)
    @acc_vec = alignment + cohesion + separation
  end

  def getPopulation()
    return $population
  end
end