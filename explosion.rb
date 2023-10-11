class Explosion
    attr_accessor :x, :y, :radius, :images, :image_index, :finished 
    def initialize(window, x, y)
        @x = x
        @y = y
        @radius = 30 
        @images = Gosu::Image.load_tiles('image/explosions.png', 60, 60) 
        @image_index = 0 
        @finished = false
    end
end