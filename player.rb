class Player 
    attr_accessor :x, :y, :angle, :image, :velocity_x, :velocity_y, :radius, :window
    def initialize(window)
        @x = 350
        @y = 350
        @angle = 0 
        @image = Gosu::Image.new('image/player.png')
        @velocity_x = 0 
        @velocity_y = 0 
        @radius = 20
        @window = window
    end
end
