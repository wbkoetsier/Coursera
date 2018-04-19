# Mini-project week 8 - RiceRocks
# 14 June 2013
# http://www.codeskulptor.org/#user16_e6F8aer7ZhTPlYb_8.py

## this is the original CodeSkulptor code I created during the course [wbkoetsier 24Jun2015]

#### Imports
import simplegui
import math
import random


#### Globals
## game
game_in_progress = False

## user interface
WIDTH = 800
HEIGHT = 600
score = 0
lives = 3
time = 0.5 # for background animation

## ship
# extra space factor for ship collision with spawning asteroids
EXTRA_SPACE = 2

## asteroids
# asteroid movement [start, stop)
POS_RANGE = dict({'hor' : (0, WIDTH), 'ver': (0, HEIGHT)})
VEL_RANGE = dict({'hor' : (-5, 5), 'ver': (-5, 5)}) #7
ANGLE_VEL_RANGE = (-.05, .05)
# asteroid group
MAX_AST = 12
asteroid_group = set()
asteroid_id = 1
asteroid_id_str = 'asteroid'
asteroid_count = 0

## missiles
missile_group = set()
missile_id = 1
missile_id_str = 'missile'


#### Helper functions
# transformations
def angle_to_vector(ang):
    ''' Convert angle to a vector '''
    return [math.cos(ang), math.sin(ang)]

def dist(p, q):
    ''' Now go away, or I shall taunt you a second time! '''
    return math.sqrt((p[0] - q[0]) ** 2+(p[1] - q[1]) ** 2)

def random_number(start, stop):
    '''
    Get random number from range [start, stop)
    Remove zero from range if start is negative and stop is positive
    '''
    if abs(start) == start:
        return random.randrange(start, stop)
    else:
        return random.choice([random.randrange(start, -1),
                             random.randrange(1, stop)])

def process_sprite_group(sprite_group, canvas):
    ''' Draw and update each sprite in the set '''
    
    global missile_group
    
    for sprite in sprite_group:
        sprite.draw(canvas)
        if sprite.update():
            missile_group.remove(sprite)

def group_to_group_collision(sprite_group1, sprite_group2):
    '''
    Checks if elements in sprite group 1 collide with any 
    element from group 2. If that is the case, the group 1
    element is removed from its group.
    Returns number of elements from group 1 that collided
    with elements from group 2.
    '''
    
    number_of_elements = 0
    
    for s in set(sprite_group1):
        num = single_to_group_collision(sprite_group2, s)
        if num:
            sprite_group1.remove(s)
            number_of_elements += 1        
            
    return number_of_elements

def single_to_group_collision(sprite_group, sprite):
    '''
    Checks if the single sprite collides with any sprite
    from the group. If that is the case, the latter is
    removed from its group.
    Returns number of collisions.
    '''
    
    number_of_collisions = 0
    
    for s in set(sprite_group):
        
        if s.collision(sprite):
            
            sprite_group.remove(s)
            number_of_collisions += 1
            
    return number_of_collisions

def reset_game():
    ''' Reset game values when game ends'''
    
    global my_ship, asteroid_group, missile_group
    global lives, score, soundtrack
    
    # stop sounds except soundtrack
    missile_sound.pause()    
    ship_thrust_sound.pause()    
    explosion_sound.pause()
    
    # restart soundtrack
    soundtrack.rewind()
    
    # destroy old ship
    my_ship = None
    
    # destroy all existing asteroids and missiles
    asteroid_group = set()
    missile_group = set()
    
def calc_sprite_properties(pos_range, vel_range, angle_range, angle_vel_range):
    '''
    Calculate random position, velocity, angle and angle
    velocity for a sprite, given their ranges
    pos and vel ranges ( [strt, stp) ) are dictionaries:
    {'hor': [strt, stp], 'ver': [strt, stp]}
    angle and angle_vel are lists [strt, stp]
    angle, in degrees, would usually be [0, 361)
    '''
    # get the random number for each range, correct for non-int
    h_pos = random_number(pos_range['hor'][0], pos_range['hor'][1])
    v_pos = random_number(pos_range['ver'][0], pos_range['ver'][1])
    h_vel = random_number(vel_range['hor'][0] * 10, vel_range['hor'][1] * 10)
    v_vel = random_number(vel_range['ver'][0] * 10, vel_range['ver'][1] * 10)
    angle_vel = random_number(angle_vel_range[0] * 100, angle_vel_range[1] * 100)
    
    # update pos, vel, ang, ang_vel
    pos = [h_pos, v_pos]
    vel = [h_vel / 10, v_vel / 10]
    angle = math.radians(random.randrange(angle_range)) #0, 360
    angle_velocity = angle_vel / 100
    
    # return values
    return [pos, vel, angle, angle_velocity]

def exit_all():
    # by Helder Sepulveda
    # https://class.coursera.org/interactivepython-002/forum/thread?thread_id=7534&post_id=37130#post-37130

    soundtrack.pause()    
    missile_sound.pause()    
    ship_thrust_sound.pause()    
    explosion_sound.pause()    
    timer.stop()

#### Classes
class ImageInfo:
    def __init__(self, center, size, radius = 0, lifespan = None, animated = False):
        ''' Set the image properties '''
        self.center = center
        self.size = size
        self.radius = radius
        if lifespan:
            self.lifespan = lifespan
        else:
            self.lifespan = float('inf')
        self.animated = animated

    def get_center(self):
        ''' Getter for image centre '''
        return self.center

    def get_size(self):
        ''' Getter for image size '''
        return self.size

    def get_radius(self):
        ''' Getter for image radius, defaults to 0 '''
        return self.radius

    def get_lifespan(self):
        ''' Getter for image lifespan, defaults to no lifespan '''
        return self.lifespan

    def get_animated(self):
        ''' Getter for 'animated' boolean '''
        return self.animated

#### Artwork globals - use ImageInfo objects
# art assets created by Kim Lathrop, may be freely re-used in non-commercial 
# projects, please credit Kim
    
# debris images - debris1_brown.png, debris2_brown.png, debris3_brown.png, debris4_brown.png
#                 debris1_blue.png, debris2_blue.png, debris3_blue.png, debris4_blue.png, debris_blend.png
debris_info = ImageInfo([320, 240], [640, 480])
debris_image = simplegui.load_image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/debris2_blue.png")

# nebula images - nebula_brown.png, nebula_blue.png
nebula_info = ImageInfo([400, 300], [800, 600])
nebula_image = simplegui.load_image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/nebula_blue.png")

# splash image
splash_info = ImageInfo([200, 150], [400, 300])
splash_image = simplegui.load_image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/splash.png")

# ship image
ship_info = ImageInfo([45, 45], [90, 90], 35)
ship_image = simplegui.load_image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/double_ship.png")

# missile image - shot1.png, shot2.png, shot3.png
missile_info = ImageInfo([5,5], [10, 10], 3, 50)
missile_image = simplegui.load_image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/shot2.png")

# asteroid images - asteroid_blue.png, asteroid_brown.png, asteroid_blend.png
asteroid_info = ImageInfo([45, 45], [90, 90], 40)
asteroid_image = simplegui.load_image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/asteroid_blue.png")

# animated explosion - explosion_orange.png, explosion_blue.png, explosion_blue2.png, explosion_alpha.png
explosion_info = ImageInfo([64, 64], [128, 128], 17, 24, True)
explosion_image = simplegui.load_image("http://commondatastorage.googleapis.com/codeskulptor-assets/lathrop/explosion_alpha.png")

# sound assets purchased from sounddogs.com, please do not redistribute
soundtrack = simplegui.load_sound("http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/soundtrack.mp3")
missile_sound = simplegui.load_sound("http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/missile.mp3")
missile_sound.set_volume(.5)
ship_thrust_sound = simplegui.load_sound("http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/thrust.mp3")
ship_thrust_sound.set_volume(1)
explosion_sound = simplegui.load_sound("http://commondatastorage.googleapis.com/codeskulptor-assets/sounddogs/explosion.mp3")

## end artwork globals

class Ship:
    ''' A ship '''
    
    # some local constants
    ACCEL_FACTOR = .1
    FRICTION_FACTOR = .99
    MISS_FACTOR = 10
    SCREEN_SIZE = [WIDTH, HEIGHT]
    
    def __init__(self, pos, vel, angle, image, info, sprite_id, sound = None):
        ''' Initialise a ship object: set its initial properties '''
        self.pos = [pos[0],pos[1]]
        self.vel = [vel[0],vel[1]]
        self.thrust = False
        self.angle = angle
        self.angle_vel = 0
        self.forward_vector = [0, 0]
        self.image = image
        self.image_center = info.get_center()
        self.image_size = info.get_size()
        self.radius = info.get_radius()
        self.sound = sound
        self.sprite_id = sprite_id
        
    def get_id(self):
        return self.sprite_id

    def get_position(self):
        return self.pos
    
    def set_position_velocity(self, p, v):
        self.pos = p
        self.vel = v
        
    def get_velocity(self):
        return self.vel
    
    def get_radius(self):
        return self.radius
    
    def draw(self,canvas):
        ''' Ship's draw handler '''
        if self.thrust:
            # find the ship image with thrusters on
            self.image_center[0] = self.image_size[0] + (self.image_size[0] / 2)
            self.sound.play()
        else:
            self.image_center[0] = self.image_size[0] / 2
            self.sound.pause()
            self.sound.rewind()
        
        canvas.draw_image(self.image, 
                          self.image_center, self.image_size, 
                          self.pos, self.image_size, 
                          self.angle)

    def update(self):
        ''' Update ship's properties '''
        
        if self.thrust:
            # calculate forward vector
            self.forward_vector = angle_to_vector(self.angle)
            
            # reduce forward vector by a consant factor and update velocity
            for i in range(2):
                self.forward_vector[i] *= Ship.ACCEL_FACTOR
                self.vel[i] += self.forward_vector[i]
        
        # add friction to velocity, update position and wrap ship around the screen
        for i in range(2):
            self.vel[i] *= Ship.FRICTION_FACTOR
            self.pos[i] = (self.pos[i] + self.vel[i]) % Ship.SCREEN_SIZE[i]
        
        # update the angle
        self.angle += self.angle_vel

    def increment_angle_velocity(self, accel):
        ''' Increment the angle velocity with the acceleration factor '''
        self.angle_vel += Ship.ACCEL_FACTOR
        
    def decrement_angle_velocity(self, accel):
        ''' Decrement the angle velocity with the acceleration factor '''
        self.angle_vel -= Ship.ACCEL_FACTOR
        
    def set_angle_velocity(self, a_vel):
        ''' Set the angle velocity '''
        self.angle_vel = a_vel
        
    def toggle_thrusters(self):
        ''' Toggle between thrusters is True or False '''
        self.thrust = not self.thrust
    
    def shoot(self):
        ''' Shoot a missile '''
        global missile_group, missile_id
        
        # calculate initial missile properties
        miss_pos = [0, 0]
        miss_vel = [0, 0]
        angle_vector = angle_to_vector(self.angle)
        for i in range(2):
            miss_pos[i] = (self.pos[i] + 
                           angle_vector[i] * self.radius)
            miss_vel[i] = (self.vel[i] + 
                           angle_vector[i] * Ship.MISS_FACTOR)

        # spawn missile into missile group
        missile_group.add(Sprite(miss_pos, miss_vel, self.angle, 0,
                          missile_image, missile_info, 
                          'missile-' + str(missile_id), missile_sound))
        
        # update missile id
        missile_id += 1
        
class Sprite:
    
    # local constants
    SCREEN_SIZE = [WIDTH, HEIGHT]
    
    def __init__(self, pos, vel, ang, ang_vel, image, info, sprite_id, sound = None):
        ''' Initialise a sprite object: set its initial properties '''
        self.pos = [pos[0], pos[1]]
        self.vel = [vel[0], vel[1]]
        self.angle = ang
        self.angle_vel = ang_vel
        self.image = image
        self.image_center = info.get_center()
        self.image_size = info.get_size()
        self.radius = info.get_radius()
        self.lifespan = info.get_lifespan()
        self.animated = info.get_animated()
        self.age = 0
        self.sprite_id = sprite_id
        if sound:
            sound.rewind()
            sound.play()

    def get_id(self):
        return self.sprite_id
    
    def get_position(self):
        return self.pos
    
    def get_radius(self):
        return self.radius
   
    def draw(self, canvas):
        ''' Sprite object's draw handler '''
        canvas.draw_image(self.image,
                          self.image_center, self.image_size, 
                          self.pos, self.image_size, 
                          self.angle)

    def update(self):
        ''' Update sprite object properties '''
        
        # update position and wrap object around the screen
        for i in range(2):
            self.pos[i] = (self.pos[i] + self.vel[i]) % Sprite.SCREEN_SIZE[i]
        
        # update angle
        self.angle += self.angle_vel
        
        # update missile age
        if missile_id_str in self.sprite_id:
            if self.age >= self.lifespan:
                return True
            else:
                self.age += 1
                return False

    def collision(self, another_sprite, extra_space = 0):
        ''' Return True when this sprite and another collide, False otherwise '''

        distance = dist(self.pos, another_sprite.get_position())
        if distance < self.radius + extra_space + another_sprite.get_radius():
            return True
        else:
            return False
                

#### Event handlers
def draw(canvas):
    ''' Canvas draw handler, is called at frame rate (60 times/sec) '''
    
    global game_in_progress, time, lives, score
    
    # animate background
    time += 1
    center = debris_info.get_center()
    size = debris_info.get_size()
    wtime = (time / 8) % center[0]
    canvas.draw_image(nebula_image, nebula_info.get_center(), nebula_info.get_size(), [WIDTH / 2, HEIGHT / 2], [WIDTH, HEIGHT])
    canvas.draw_image(debris_image, [center[0] - wtime, center[1]], [size[0] - 2 * wtime, size[1]], 
                                [WIDTH / 2 + 1.25 * wtime, HEIGHT / 2], [WIDTH - 2.5 * wtime, HEIGHT])
    canvas.draw_image(debris_image, [size[0] - wtime, center[1]], [2 * wtime, size[1]], 
                                [1.25 * wtime, HEIGHT / 2], [2.5 * wtime, HEIGHT])

    if game_in_progress:
        
        # draw and update ship
        my_ship.draw(canvas)
        my_ship.update()

        # draw and update asteroids
        process_sprite_group(asteroid_group, canvas)
        
        # check if ship collides with any asteroid and adjust number of lives
        lives -= single_to_group_collision(asteroid_group, my_ship)
        
        # but stop game when all lives are lost
        if not lives:
            game_in_progress = False
            reset_game()
            
        # draw and update missiles
        process_sprite_group(missile_group, canvas)
        
        # check for missile/asteroid collisions
        score += group_to_group_collision(missile_group, asteroid_group)
        
    else:

        # draw splash screen
        canvas.draw_image(splash_image, splash_info.get_center(), 
                          splash_info.get_size(), [WIDTH / 2, HEIGHT / 2], 
                          splash_info.get_size())
        
        # play soundtrack
        soundtrack.play()

    # user interface - lives and score
    l_txt = "Lives: " + str(lives)
    s_txt = "Score: " + str(score)
    txt_size = 30
    txt_col = "MediumVioletRed"
    l_point = [30, 35]
    s_point = [WIDTH - frame.get_canvas_textwidth(s_txt, txt_size) - l_point[0],
               l_point[1]]
    canvas.draw_text(l_txt, l_point, txt_size, txt_col)
    canvas.draw_text(s_txt, s_point, txt_size, txt_col)
       
def asteroid_spawner():
    ''' Timer handler: spawn a new asteroid with random properties at every tick '''

    global asteroid_group, asteroid_count, asteroid_id
    
    # use this timer handler to exit when the frame is closed
    # by Helder Sepulveda
    # https://class.coursera.org/interactivepython-002/forum/thread?thread_id=7534&post_id=37130#post-37130
    if frame.get_canvas_textwidth("test", 50) < 10:        
        exit_all()
    
    # do not spawn when no game is in progress!
    if game_in_progress:
    
        # limit the number of asteroids on the canvas
        if len(asteroid_group) <= MAX_AST - 1:
            
            # recursively check if the asteroid isn't too close to the ship
            add = False
            while not add:
                
                # get random properties for this asteroid
                properties = calc_sprite_properties(POS_RANGE, VEL_RANGE, 0, ANGLE_VEL_RANGE)
                
                # create the asteroid
                asteroid = Sprite(properties[0], properties[1],
                                  properties[2], properties[3],
                                  asteroid_image, asteroid_info, 
                                  asteroid_id_str + str(asteroid_id))
                
                # calculate the neccesary extra space based on the ship's 
                # velocity and a constant factor
                extra_space = (my_ship.get_velocity()[0] + my_ship.get_velocity()[1]) / 2
                extra_space *= EXTRA_SPACE
                
                # check if the asteroid isn't too close to the ship
                if not asteroid.collision(my_ship, extra_space):
                    
                    # and that's far enough! :P
                    add = True

            # add an asteroid with the above properties to the asteroid group set
            asteroid_group.add(asteroid)
            
            # update asteroid count and increase asteroid id number
            asteroid_count = len(asteroid_group)
            asteroid_id += 1
        
def keydown_handler(key):
    ''' Keydown handler '''
    
    if game_in_progress:
        angle_vel_accel = .15
        if key == simplegui.KEY_MAP["right"]:
            # set accelerationfactor for clockwise rotation
            my_ship.increment_angle_velocity(angle_vel_accel)
            
        elif key == simplegui.KEY_MAP["left"]:
            # set accelerationfactor for counterclockwise rotation
            my_ship.decrement_angle_velocity(angle_vel_accel)
        
        elif key == simplegui.KEY_MAP["up"]:
            # turn on thrusters
            my_ship.toggle_thrusters()
            
        elif key == simplegui.KEY_MAP["space"]:
            # shoot a missile
            my_ship.shoot()
            
        else:
            print "pressed unmapped key", key

#def keyup(key):
#    global angle_change, ship_turn
#    if in_action and not paused:
#        def stop_turn():
#            my_ship.turn=0
#        def stop_thrust():
#            my_ship.thrust=False
#            my_ship.sound.rewind()
#        def none():
#            pass
#        keydict={"left":stop_turn, "right":stop_turn, "up":stop_thrust, "space":none}
#        for k in keydict:
#            if key==simplegui.KEY_MAP[k]:
#                keydict[k]()

def keyup_handler(key):
    ''' Keyup handler '''
    
    if game_in_progress:
            
        if (key == simplegui.KEY_MAP["right"] or
            key == simplegui.KEY_MAP["left"]):
            # set accelerationfactor for rotation back to 0
            my_ship.set_angle_velocity(0)
            
        elif key == simplegui.KEY_MAP["up"]:
            # turn off thrusters
            my_ship.toggle_thrusters()
        
def mouse_click_handler(pos):
    ''' Mouse click handler '''
    
    global game_in_progress, my_ship, lives, score
    
    # splash screen - taken from week 8 template
    center = [WIDTH / 2, HEIGHT / 2]
    size = splash_info.get_size()
    inwidth = (center[0] - size[0] / 2) < pos[0] < (center[0] + size[0] / 2)
    inheight = (center[1] - size[1] / 2) < pos[1] < (center[1] + size[1] / 2)
    
    if (not game_in_progress) and inwidth and inheight:
        
        # reset lives and score
        lives = 3
        score = 0
        
        game_in_progress = True
        
        # create ship
        my_ship = Ship([WIDTH / 2, HEIGHT / 2], [0, 0], 0,
                   ship_image, ship_info, 'Ship', ship_thrust_sound)
        

#### Create frame
frame = simplegui.create_frame("RiceRocks", WIDTH, HEIGHT)

#### Register event handlers
frame.set_draw_handler(draw)
frame.set_keydown_handler(keydown_handler)
frame.set_keyup_handler(keyup_handler)
frame.set_mouseclick_handler(mouse_click_handler)

timer = simplegui.create_timer(1000.0, asteroid_spawner)

#### Get things rolling
reset_game()
timer.start()
frame.start()
