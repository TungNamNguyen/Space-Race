C:\Desktop\Year 1 Semester 1 Swinburne\COS10009\custom_program_final\custom_program.rbrequire 'gosu'
require_relative 'player'
require_relative 'enemy'
require_relative 'bullet'
require_relative 'explosion'
require_relative 'boss'
require_relative 'ability'
require_relative 'ally'
#Player
def turn_right_player(player)
    player.angle += 2.5
end
def turn_left_player(player)
    player.angle -= 2.5
end

def accelerate(player)
    player.velocity_x += Gosu.offset_x(player.angle, 1.1)
    player.velocity_y += Gosu.offset_y(player.angle, 1.1)
end

def move_player(player)
    player.x += player.velocity_x
    player.y += player.velocity_y
    player.velocity_x *= 0.9
    player.velocity_y *= 0.9
        if player.x > player.window.width - player.radius 
            player.x = player.window.width - player.radius
        end

        if player.x < player.radius 
            player.velocity_x = 0 
            player.x = player.radius
        end

        if player.y > player.window.height - player.radius 
            player.velocity_y = 0
            player.y = player.window.height - player.radius
        end
end
def draw_player(player)
    player.image.draw_rot(player.x, player.y, 1, player.angle)
end

#Ally
def move_ally(ally)
    ally.y -= 4
end
def draw_ally(ally)
    ally.image.draw(ally.x-ally.radius, ally.y-ally.radius, 1)
end

#Ability
def move_ability(ability)
    ability.y += 1.5
end
def draw_ability(ability)
    ability.image.draw(ability.x-ability.radius, ability.y-ability.radius, 1)
end

#Boss
def move_boss(boss)
    boss.y += 1

end
def draw_boss(boss)
    boss.image.draw(boss.x-boss.radius, boss.y-boss.radius, 1)
end

#Bullet
def move_bullet(bullet)
    bullet.x += Gosu::offset_x(bullet.direction, 5)
    bullet.y += Gosu::offset_y(bullet.direction, 5)
end
def draw_bullet(bullet)
    bullet.image.draw(bullet.x - bullet.radius, bullet.y - bullet.radius, 1)
end
def check_onscreen(bullet)
    right = bullet.window.width + bullet.radius 
    left = -bullet.radius 
    top = -bullet.radius 
    bottom = bullet.window.height + bullet.radius 
    bullet.x > left and bullet.x < right and bullet.y > top and bullet.y < bottom 
end

#Enemy 
def move_enemy(enemy)
    enemy.y += 2.5
end
def draw_enemy(enemy)
    enemy.image.draw(enemy.x-enemy.radius, enemy.y-enemy.radius, 1)
end

#Explosion
def draw_explosion(explosion)
    if explosion.image_index < explosion.images.count 
        explosion.images[explosion.image_index].draw(explosion.x - explosion.radius, explosion.y - explosion.radius, 2)
        explosion.image_index += 1
    else
        explosion.finished = true
    end
end

class SpaceRace < Gosu::Window 
    WIDTH = 800
    HEIGHT = 640
    ENEMY_FREQUENCY = 0.05
    BOSS_FREQUENCY = 0.005
    MAX_ENEMIES = 200
    MAX_BOSSES = 100
    ABILITY_FREQUENCY = 0.003
    def initialize 
        super(WIDTH,HEIGHT) 
        self.caption = 'Space Race'
        @game_logo = Gosu::Image.new('image/space_race_logo.png')
        @start_image = Gosu::Image.new('image/background.png')
        @scene = :start
        @start_option_1 = "New Game (Press 1)"
        @start_option_2 = "Quit (Press 2)"
        @start_option_font = Gosu::Font.new(28)
        @start_music = Gosu::Song.new('sounds/too_strong1.2.ogg') 
        @start_music.play(true)
    end
    def draw 
        case @scene
        when :start
            draw_start
        when :game
            draw_game
        when :end 
            draw_end
        end
    end

    def draw_start
        @start_image.draw(0,0,0)
        @game_logo.draw(250,20,0)
        @start_option_font.draw(@start_option_1,350,360,1,1,1,Gosu::Color::FUCHSIA)
        @start_option_font.draw(@start_option_2,350,400,1,1,1,Gosu::Color::FUCHSIA)
    end

    def draw_game
        @in_game_font.draw("Health: #{@health}",600,0,1,1,1,Gosu::Color::FUCHSIA)
        @in_game_font.draw("Score: #{@score}",600,50,1,1,1,Gosu::Color::FUCHSIA)
        @in_game_font.draw("Enemies Left: #{MAX_ENEMIES - @enemies_destroyed}",100,0,1,1,1,Gosu::Color::FUCHSIA)
        @in_game_font.draw("Bosses Left: #{MAX_BOSSES - @bosses_destroyed}",100,50,1,1,1,Gosu::Color::FUCHSIA)
        @ingame_background.draw(0,0,0)
        draw_player(@player)
        @enemies.each do |enemy|
            draw_enemy(enemy)
        end

        @bullets.each do |bullet|
            draw_bullet(bullet)
        end

        @explosions.each do |explosion|
            draw_explosion(explosion)
        end

        @bosses.each do |boss|
            draw_boss(boss)
        end

        @abilities.each do |ability|
            draw_ability(ability)
        end
      
        @allies.each do |ally|
            draw_ally(ally)
        end

    end

    def draw_end
        @message_font.draw(@message,250,200,1,1,1,Gosu::Color::FUCHSIA)
        @message_font.draw(@message2,250,250,1,1,1,Gosu::Color::FUCHSIA)
        @message_font.draw(@bottom_message,180,540,1,1,1,Gosu::Color::FUCHSIA)
    end

    def update 
        case @scene
        when :game
            update_game
        end
    end

    def button_down(id)
        case @scene
        when :start 
            button_down_start(id)
        when :game 
            button_down_game(id)
        when :end
            button_down_end(id)
        end
    end

    def button_down_start(id)
        if id == Gosu::Kb1
            initialize_game
        elsif id == Gosu::Kb2
            close
        end
    end

    def initialize_game
        @player = Player.new(self) 
        @enemies = [] 
        @bullets = [] 
        @explosions = []
        @bosses = []
        @abilities = []
        @allies = []
        @scene = :game
        @score = 0 
        @in_game_font = Gosu::Font.new(20)
        @bosses_destroyed = 0 
        @bosses_appeared = 0 
        @enemies_appeared = 0 
        @enemies_destroyed = 0 
        @game_music = Gosu::Song.new('sounds/it_takes_a_hero.wav') 
        @game_music.play(true)
        @explosion_sound = Gosu::Sample.new('sounds/explosion.wav')
        @shooting_sound = Gosu::Sample.new('sounds/laser_shooting_sfx.wav')
        @ability_sound = Gosu::Sample.new('sounds/ability.wav')
        @boss_sound = Gosu::Sample.new('sounds/boss_dying.wav')
        @ingame_background = Gosu::Image.new('image/back.jpg')
        @health = 5 
    end

    def update_game
        turn_left_player(@player) if button_down?(Gosu::KbLeft)
        turn_right_player(@player) if button_down?(Gosu::KbRight)
        accelerate(@player) if button_down?(Gosu::KbUp)
        move_player(@player)

        if rand < ENEMY_FREQUENCY #create enemy 
            @enemies.push Enemy.new(self)
            @enemies_appeared += 1 
        end
       
        if rand < BOSS_FREQUENCY #create boss 
            @bosses.push Boss.new(self)
            @bosses_appeared += 1
        end

        if rand < ABILITY_FREQUENCY #create ability 
            @abilities.push Ability.new(self)
        end

        @enemies.each do |enemy| #move enemy 
            move_enemy(enemy)
        end

        @bosses.each do |boss| # move boss 
            move_boss(boss)
        end

        @bullets.each do |bullet| #move bullet 
            move_bullet(bullet)
        end

        @abilities.each do |ability| #move ability 
            move_ability(ability)
        end

        @allies.each do |ally| #move ally 
            move_ally(ally)
        end

        @enemies.dup.each do |enemy|  #create collision between enemy and bullet 
            @bullets.dup.each do |bullet|
                distance_enemy_bullet = Gosu.distance(enemy.x, enemy.y, bullet.x, bullet.y) 
                if distance_enemy_bullet < enemy.radius + bullet.radius 
                    @enemies.delete enemy 
                    @bullets.delete bullet
                    @explosions.push Explosion.new(self, enemy.x, enemy.y)
                    @enemies_destroyed += 1
                    @score += 5
                    @explosion_sound.play
                end
            end
        end

        @abilities.dup.each do |ability| #create collision between player an ability 
            distance_player_ability = Gosu::distance(ability.x, ability.y, @player.x, @player.y)
            if distance_player_ability < @player.radius + ability.radius
                @ability_sound.play
                @allies.push Ally.new(self)
                @abilities.delete ability 
                @health += 1
            end
        end

        @enemies.dup.each do |enemy| #create collision with enemy and ally 
            @allies.dup.each do |ally|
                distance_ally_enemy = Gosu::distance(ally.x, ally.y, enemy.x, enemy.y)
                if distance_ally_enemy < ally.radius + enemy.radius
                    @explosions.push Explosion.new(self, enemy.x, enemy.y)
                    @explosion_sound.play
                    @enemies.delete enemy
                    @enemies_destroyed += 1 
                    @score += 5 
                end
            end
        end

        @bosses.dup.each do |boss| #create collision between boss and ally 
            @allies.dup.each do |ally|
                distance_ally_boss = Gosu::distance(ally.x, ally.y, boss.x, boss.y)
                if distance_ally_boss < ally.radius + boss.radius
                    @explosions.push Explosion.new(self, boss.x, boss.y)
                    @boss_sound.play
                    @bosses.delete boss
                    @bosses_destroyed += 1 
                    @score += 15
                end
            end
        end

        @bosses.dup.each do |boss|  #create collision between boss and bullet 
            @bullets.dup.each do |bullet|
                distance_boss_bullet = Gosu.distance(boss.x, boss.y, bullet.x, bullet.y) 
                if distance_boss_bullet < boss.radius + bullet.radius
                    boss.hp -= 1 
                    @bullets.delete bullet
                    @explosions.push Explosion.new(self, boss.x, boss.y)
                    @explosion_sound.play
                    if boss.hp == 0 
                        @bosses.delete boss
                        @bosses_destroyed += 1 
                        @score += 15
                        @boss_sound.play
                    end
                end
            end
        end

        @explosions.dup.each do |explosion| #delete ecplosion when finished
            @explosions.delete explosion if explosion.finished
        end

        @enemies.dup.each do |enemy| #delete enemy 
            if enemy.y > HEIGHT + enemy.radius
                @enemies.delete enemy 
            end
        end

        @allies.dup.each do |ally| #delete ally 
            if ally.y < -ally.radius 
                @allies.delete ally 
            end
        end
 
        @bullets.dup.each do |bullet| #delete bullet 
            @bullets.delete bullet unless check_onscreen(bullet)
        end
        
        initialize_end(:count_reached)  if @enemies_appeared > MAX_ENEMIES or @bosses_appeared > MAX_BOSSES

        @enemies.each do |enemy| #lose when health = 0 (create collision between enemy and player)
            distance1 = Gosu::distance(enemy.x, enemy.y, @player.x, @player.y)
            if distance1 < @player.radius + enemy.radius 
                @enemies.delete enemy 
                @explosions.push Explosion.new(self, enemy.x, enemy.y)
                @explosion_sound.play
                @health -= 1 
            end
            initialize_end(:hit_by_enemy) if @health == 0 
        end

        @bosses.each do |boss| #Lose when a boss reaches base or player gets hit by a boss
            distance2 = Gosu::distance(boss.x, boss.y, @player.x, @player.y)
            initialize_end(:hit_by_boss) if distance2 < @player.radius + boss.radius
            initialize_end(:boss_reach_base) if boss.y > HEIGHT + boss.radius
        end

        initialize_end(:off_border) if @player.y < -@player.radius #lose when player reachs the top border 
    end
    
    def button_down_game(id)
        if id == Gosu::KbSpace 
            @bullets.push Bullet.new(self, @player.x, @player.y, @player.angle)
            @shooting_sound.play(0.3)
        end
    end
    
    def initialize_end(fate) #ending screen 
        case fate
        when :count_reached
            @message = "You SURVIVED."
            @message2 = "Score: #{@score}"
        when :hit_by_enemy
            @message = "You were killed by an enemy"
            @message2 = "Score: #{@score}"
        when :hit_by_boss
            @message = "You were smashed by a boss"
            @message2 = "Score: #{@score}"
        when :off_border
            @message = "You moved out of the safe zone"
            @message2 = "Score: #{@score}"
        when :boss_reach_base
            @message = "BOSS reached the base"
            @message2 = "Score: #{@score}"
        end
        @bottom_message = "Press P to play again, or Q to quit "
        @message_font = Gosu::Font.new(28)
        @scene = :end
        @end_music = Gosu::Song.new('sounds/face_the_facts.wav') 
        @end_music.play(true)
    end

    def button_down_end(id) #run the game again or quit to the main menu 
        if id == Gosu::KbP
            initialize_game
        elsif id == Gosu::KbQ
            initialize
        end
    end
end
window = SpaceRace.new
window.show