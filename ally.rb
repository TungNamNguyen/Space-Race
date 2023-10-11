class Ally
    attr_accessor :x, :y, :radius, :image
    def initialize(window)
        @radius = 20
        @x = rand(window.width - 2 * @radius) + @radius 
        @y = 620 
        @image = Gosu::Image.new('image/ally.png')
    end
end
    