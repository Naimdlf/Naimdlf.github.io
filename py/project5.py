'''
Naim Ferris
Project Variation #2 (please change the number)
Description: Removed unecessary code and unused functions. Changed cloud number making it look like one big cloud instead of some small ovals. Up dated the locations of some items. Refactored the draw scene code. Used constants and avoided numbers
'''
# loads the Turtle graphics module, which is a built-in library in Python
import turtle
import math

# Constants
GROUND_WIDTH = 10000
GROUND_HEIGHT = -300
GROUND_POSITION = (-500, -500)

SUN_RADIUS = 50
SUN_POSITION = (150, 200)
SUN_COLOR = "yellow"

HOUSE_WIDTH = 100
HOUSE_HEIGHT = 200
HOUSE_POSITION = (0, 0)
HOUSE_COLOR = "red"
ROOF_COLOR = "brown"

DOOR_WIDTH = 20
DOOR_HEIGHT = 60
DOOR_POSITION = (50, -200)
DOOR_COLOR = "yellow"

WINDOW_COLOR = "blue"
WINDOW_SIZE = 20
WINDOW_POSITIONS = [(20, -70), (20, -40)]

GROUND_COLOR = "green"
SKY_COLOR = "skyblue"

DEFAULT_WINDOW_SIZE = 20

# turtle Initialization
def setup_turtle():
    """Initialize turtle with standard settings"""
    t = turtle.Turtle()
    t.speed(0)  # Fastest speed
    screen = turtle.Screen()
    screen.title("Turtle Graphics Assignment")
    return t, screen

# shapes
# rectangle
def draw_rectangle(t, width, height, fill_color=None):
    """Draw a rectangle with optional fill"""
    if fill_color:
        t.fillcolor(fill_color)
        t.begin_fill()
    for _ in range(2):
        t.forward(width)
        t.right(90)
        t.forward(height)
        t.right(90)
    if fill_color:
        t.end_fill()

# square
def draw_square(t, size, fill_color=None):
    """Draw a square with optional fill"""
    if fill_color:
        t.fillcolor(fill_color)
        t.begin_fill()
    for _ in range(4):
        t.forward(size)
        t.right(90)
    if fill_color:
        t.end_fill()

# triangle
def draw_triangle(t, size, fill_color=None):
    """Draw an equilateral triangle with optional fill"""
    if fill_color:
        t.fillcolor(fill_color)
        t.begin_fill()
    for _ in range(3):
        t.forward(size)
        t.left(120)
    if fill_color:
        t.end_fill()

# circle
def draw_circle(t, radius, fill_color=None):
    """Draw a circle with optional fill"""
    if fill_color:
        t.fillcolor(fill_color)
        t.begin_fill()
    t.circle(radius)
    if fill_color:
        t.end_fill()

def draw_oval(t, radius_x, radius_y, fill_color=None):
    """Draw an oval centered at the turtle's current position"""
    if fill_color:
        t.fillcolor(fill_color)
        t.begin_fill()
    # Save starting position
    # middle of the oval
    center_x, center_y = t.xcor(), t.ycor() 
    # picks up the pen so the turtle does not draw to the starting point.
    t.penup()
# 361 is a full circle with smooth schape
    for angle in range(361):
        # math.radians(angle) converts degrees to radians because Python's cos and sin functions use radians. radius_x and radius_y are used to stretch the circle into an oval:
        x = center_x + radius_x * math.cos(math.radians(angle))
        y = center_y + radius_y * math.sin(math.radians(angle))
        # On the first point only (angle == 0), the turtle moves to that point without drawing, then puts the pen down to start drawing.
        if angle == 0:
            t.goto(x, y)
            t.pendown()
        else:
            t.goto(x, y)

# when the color is filled we end the shape.
    if fill_color: 
        t.end_fill()

    
    if fill_color:
        t.end_fill()

# utility
def jump_to(t, x, y):
    """Move turtle without drawing"""
    t.penup()
    t.goto(x, y)
    t.pendown()

# Main Scene
# Scene Elements
def draw_window(t, x, y, size=DEFAULT_WINDOW_SIZE, color=WINDOW_COLOR):
    jump_to(t, x, y)
    draw_square(t, size, fill_color=color)

def draw_door(t):
    jump_to(t, *DOOR_POSITION)
    draw_rectangle(t, DOOR_WIDTH, -DOOR_HEIGHT, fill_color=DOOR_COLOR)

def draw_house(t):
    jump_to(t, *HOUSE_POSITION)
    draw_rectangle(t, HOUSE_WIDTH, HOUSE_HEIGHT, fill_color=HOUSE_COLOR)
    draw_triangle(t, HOUSE_WIDTH, fill_color=ROOF_COLOR)
    draw_door(t)
    for pos in WINDOW_POSITIONS:
        draw_window(t, *pos)

def draw_sun(t):
    jump_to(t, *SUN_POSITION)
    draw_circle(t, SUN_RADIUS, fill_color=SUN_COLOR)

def draw_ground(t):
    jump_to(t, *GROUND_POSITION)
    draw_rectangle(t, GROUND_WIDTH, GROUND_HEIGHT, fill_color=GROUND_COLOR)

def draw_clouds(t):
    cloud_positions = [(-50, 200), (-200, 150), (-280, 210), (-170, 220)]
    for x, y in cloud_positions:
        jump_to(t, x, y)
        draw_oval(t, 100, 50, fill_color="white")

# Main Scene
def draw_scene(t):
    screen = t.getscreen()
    screen.bgcolor(SKY_COLOR)
    draw_sun(t)
    draw_clouds(t)
    draw_ground(t)
    draw_house(t)

def main():
    t, screen = setup_turtle()
    draw_scene(t)
    screen.mainloop()

if __name__ == "__main__":
    main()




