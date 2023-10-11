class Bullet
    attr_accessor :x, :y, :radius, :direction, :image, :window
    def initialize(window, x, y, angle)
        @x = x 
        @y = y
        @direction = angle 
        @image = Gosu::Image.new('image/new_bullet.png')
        @radius = 12.5
        @window = window
    end
end