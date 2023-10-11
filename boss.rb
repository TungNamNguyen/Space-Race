class Boss
    attr_accessor :x, :y, :radius, :image, :hp
    def initialize(window)
        @radius = 70
        @x = rand(window.width - 2 * @radius) + @radius 
        @y = 0 
        @image = Gosu::Image.new('image/boss.png')
        @hp = 12
    end
end
