import turtle as t

t.getscreen()._root.focus_force()

def draw_polygon(length, sides):
    angle = 360 / sides
    """
    I understood that I can use the modulo operator to cycle through colors based on the number of sides. It works just like JS except the sides % 3==0, is dividing the sides by 3 and seeing if the remainder is 0. The code will stop after the first true condition making some of the code redundent. I just modified the existing code using a Elif function I looked up on W3Schools https://www.w3schools.com/python/python_conditions.asp
    """
    # Rest of the code g oes here...
    if sides % 3 == 0:
        t.color("red")
    elif sides % 4 == 0:
        t.color("blue")
    elif sides % 5 == 0:
        t.color("green")
    elif sides % 6 == 0:
        t.color("red")
    elif sides % 7 == 0:
        t.color("blue")
    elif sides % 8 == 0:
        t.color("green")
    elif sides % 9 == 0:
        t.color("red")
    elif sides % 10 == 0:
        t.color("blue")
    else:
        t.color("green")  # Default color if no condition matches


    for _ in range(sides):
        t.forward(length)
        t.left(angle)

draw_polygon(100, 4)  # Draw a red square
draw_polygon(100, 5)  # Draw a blue pentagon
draw_polygon(10, 100)  # Draw a red hectogon
draw_polygon(100, 3)  # Draw a blue triangle

t.done()