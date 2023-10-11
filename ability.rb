class Ability 
    attr_accessor :x, :y, :radius, :image
    def initialize(window)
        @radius = 22
        @x = rand(window.width - 2 * @radius) + @radius 
        @y = 0 
        @image = Gosu::Image.new('image/ability.png')
    end
end


