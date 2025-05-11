'''
Naim Ferris
Project Variation #1 (please change the number)

'''


# loads the Turtle graphics module, which is a built-in library in Python
import turtle
import math

def setup_turtle():
    """Initialize turtle with standard settings"""
    t = turtle.Turtle()
    t.speed(0)  # Fastest speed
    screen = turtle.Screen()
    screen.title("Turtle Graphics Assignment")
    return t, screen

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



# def draw_polygon(t, sides, size, fill_color=None):
#     """Draw a regular polygon with given number of sides"""
#     if fill_color:
#         t.fillcolor(fill_color)
#         t.begin_fill()
#     angle = 360 / sides
#     for _ in range(sides):
#         t.forward(size)
#         t.right(angle)
#     if fill_color:
#         t.end_fill()

# def draw_curve(t, length, curve_factor, segments=10, fill_color=None):
#     """
#     Draw a curved line using small line segments
    
#     Parameters:
#     - t: turtle object
#     - length: total length of the curve
#     - curve_factor: positive for upward curve, negative for downward curve
#     - segments: number of segments (higher = smoother curve)
#     - fill_color: optional color to fill if creating a closed shape
#     """
#     if fill_color:
#         t.fillcolor(fill_color)
#         t.begin_fill()
        
#     segment_length = length / segments
#     # Save the original heading
#     original_heading = t.heading()
    
#     for i in range(segments):
#         # Calculate the angle for this segment
#         angle = curve_factor * math.sin(math.pi * i / segments)
#         t.right(angle)
#         t.forward(segment_length)
#         t.left(angle)  # Reset the angle for the next segment
    
    # Reset to original heading
    # t.setheading(original_heading)
    
    if fill_color:
        t.end_fill()
        
def jump_to(t, x, y):
    """Move turtle without drawing"""
    t.penup()
    t.goto(x, y)
    t.pendown()


def draw_scene(t):
    """Draw a colorful scene with various shapes"""
    # Set background color
    screen = t.getscreen()
    screen.bgcolor("skyblue")
    
    
    # instructions
    draw_rectangle (t, 100, 200, fill_color="red")
    draw_triangle (t, 100, fill_color="brown")
    jump_to (t,50,-200)
    draw_rectangle (t, 20, -60, fill_color="yellow")
    jump_to (t, 20, -70)
    draw_square (t, 20, fill_color="blue")
    jump_to (t, 20, -40)
    draw_square (t, 20, fill_color="blue")
    jump_to (t, 150, 200)
    draw_circle (t, 50, fill_color="yellow")
    jump_to (t, -50, 200)
    draw_oval (t, 100, 50, fill_color="white")
    jump_to (t, -200, 150)
    draw_oval (t, 100, 50, fill_color="white")
    jump_to (t, -280, 210)
    draw_oval (t, 100, 50, fill_color="white")
    jump_to (t, -500, -500)
    draw_rectangle (t, 10000, -300, fill_color="green")

def main():
    t, screen = setup_turtle()
    draw_scene(t)
    screen.mainloop()


if __name__ == "__main__":
    main()




