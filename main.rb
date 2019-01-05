require 'gosu'
require "./fish.rb"

class Main < Gosu::Window
  def initialize
    super 800,600
    self.caption = "Flocking Fishes Simulation"
    createFishes(100)
  end

  def createFishes(n)
    @fishes = Array.new
    for i in 0...n
      @fishes[i] = Fish.new
    end
  end

  def update
    if Gosu.button_down?(Gosu::KB_R)
      # remove
      if $population > 0
        @fishes.pop
        $population -= 1
      end
    end

    if Gosu.button_down?(Gosu::KB_A)
      # add
      @fishes[$population] = Fish.new
    end

    if Gosu.button_down?(Gosu::KB_C)
      # print population
      puts $population
    end

    for i in 0...$population
      @fishes[i].flock(@fishes)
      @fishes[i].update
    end
  end

  def draw
    for i in 0...$population
      @fishes[i].draw
    end
  end
end

window = Main.new
window.show