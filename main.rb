require 'gosu'
require "./fish.rb"

class Main < Gosu::Window
  def initialize
    super 800,600
    self.caption = "Flocking Fishes Simulation"
    @fishes = Array.new

    for i in 0...100
      @fishes[i] = Fish.new
      #@fishes[i].warp(rand(self.width),rand(self.height))
    end

  end

  def update
    if Gosu.button_down?(Gosu::KB_R)
      # remove
      if $population > 0
        @fishes.pop()
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
      #@fishes[i].mirror()
      @fishes[i].flock(@fishes)
      @fishes[i].update()
    end
  end

  def draw
    for i in 0...$population
      @fishes[i].draw()

    end

  end
end

window = Main.new()
window.show()