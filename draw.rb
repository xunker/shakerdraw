#!/usr/bin/env ruby
require 'rubygems'
require 'sudden_motion_sensor'
require 'gosu'
include Gosu

class GameWindow < Gosu::Window
  def initialize
    @window_x = 1024; @window_y = 768
    @x_scale = ((@window_x/254)/2).ceil; @y_scale = ((@window_y/254)/2).ceil
    
    @draw_dots=true
    @dotsize = 2
    @draw_lines=true
    
    super(@window_x, @window_y, false)
    self.caption = "Sketch-n-etch"
    
    @center_x = (@window_x/2).ceil
    @center_y = (@window_y/2).ceil
    
    @positions = []
  end
  
  def update
    x,y,z = SuddenMotionSensor.values
    @cursor_x = @center_x+(x*@x_scale)
    @cursor_y = @center_y-(y*@y_scale)    
    @cursor_z = z
    
    @positions.shift if @positions.size > 100
    @positions << {:x => @cursor_x, :y => @cursor_y, :color => Color.new(0xFF0088FF + rand(z.abs ** 2))}
  end

  def draw
    @positions.each_with_index do |p, i|
      if @draw_dots
        self.draw_line(p[:x]-@dotsize, p[:y]-@dotsize, p[:color], p[:x]-@dotsize, p[:y]+@dotsize, p[:color])
        self.draw_line(p[:x]-@dotsize, p[:y]+@dotsize, p[:color], p[:x]+@dotsize, p[:y]+@dotsize, p[:color])
        self.draw_line(p[:x]+@dotsize, p[:y]+@dotsize, p[:color], p[:x]+@dotsize, p[:y]-@dotsize, p[:color])
        self.draw_line(p[:x]+@dotsize, p[:y]-@dotsize, p[:color], p[:x]-@dotsize, p[:y]-@dotsize, p[:color])
      end
      if @draw_lines
        self.draw_line(p[:x], p[:y], p[:color], @positions[i-1][:x], @positions[i-1][:y], p[:color]) unless i==0
      end
    end
  end
  
  def button_down(id)
    if id == Gosu::Button::KbEscape
      close
    end
  end  
end
  
window = GameWindow.new
window.show
