# Step 1: Set Up Python and Install Required Libraries

- Before we start coding, let's make sure everything is set up. For this game, we will use the Python curses library, which helps us work with the terminal screen.

    Install Python: Make sure Python is installed on your computer. If not, download it from python.org.

    Check Curses Library: The curses library comes pre-installed with Python on Linux and macOS. If you're using Windows, you'll need to install a special version of it called windows-curses:

    pip install windows-curses

    This command will install everything you need for the curses library on Windows.

# Step 2: How Does the Snake Game Work?

- The idea behind the Snake game is simple:

    You have a snake that moves around the screen.
    The player controls the direction of the snake using the keyboard.
    The goal is to eat food and grow longer without hitting the wall or itself.

- Let's dive into the different parts of the code and understand how each one relates to making the game run.
Step 3: Coding Step-by-Step

Below, I'll go through each part of the code and explain what it does, step-by-step.
Part 1: Import Libraries and Set Up the Screen

python

import curses
import random

    Explanation: Here we are importing two libraries: curses and random.
        curses helps us control the terminal window. It makes the terminal more interactive, like turning it into a video game screen!
        random helps us place the food randomly on the screen, so each time it feels fresh.

Part 2: Start the Game Function

python

def snake_game(stdscr):
    # Initialize the screen
    curses.curs_set(0)  # Hide the cursor
    screen_height, screen_width = stdscr.getmaxyx()
    window = curses.newwin(screen_height, screen_width, 0, 0)
    window.keypad(1)  # Enable keypad input
    window.timeout(100)  # Refresh every 100 milliseconds

    Explanation:
        curses.curs_set(0) hides the blinking cursor so it doesn't get in the way.
        stdscr.getmaxyx() gets the height and width of the terminal window. Imagine measuring the game screen so we know where the edges are.
        curses.newwin(screen_height, screen_width, 0, 0) creates a new "window" for our game, covering the whole terminal.
        window.keypad(1) enables input from arrow keys, so we can control the snake.
        window.timeout(100) makes the screen update every 100 milliseconds, which controls the speed of the snake.

Part 3: Set Up the Snake and Food

python

    # Initial position of the snake
    snake_x = screen_width // 4
    snake_y = screen_height // 2
    snake = [
        [snake_y, snake_x],
        [snake_y, snake_x - 1],
        [snake_y, snake_x - 2]
    ]

    Explanation:
        The snake starts as three blocks in the middle of the screen.
        snake_x and snake_y are the coordinates of the snake's head.
        Imagine this as the starting position of your character in a video game. We're placing the snake at the middle of the screen, ready to go!

python

    # Initial food position
    food = [screen_height // 2, screen_width // 2]
    window.addch(food[0], food[1], curses.ACS_PI)

    Explanation:
        The food is placed at the center of the screen.
        window.addch(food[0], food[1], curses.ACS_PI) draws the food on the screen using a special character (it looks like π).
        This is like placing a collectible item in a game, and we want our character (the snake) to reach it.

Part 4: Move the Snake

python

    # Initial direction of the snake
    key = curses.KEY_RIGHT

    Explanation:
        The snake starts by moving to the right. This is like pressing the right arrow key at the beginning of the game.

python

    # Start the game loop
    while True:
        # Get the next key pressed
        next_key = window.getch()
        key = key if next_key == -1 else next_key

    Explanation:
        The while True loop keeps the game running until the snake crashes.
        window.getch() checks if any key has been pressed.
        This lets the player change the direction of the snake.

python

        # Calculate the new head position
        new_head = [snake[0][0], snake[0][1]]
        if key == curses.KEY_DOWN:
            new_head[0] += 1
        if key == curses.KEY_UP:
            new_head[0] -= 1
        if key == curses.KEY_LEFT:
            new_head[1] -= 1
        if key == curses.KEY_RIGHT:
            new_head[1] += 1

    Explanation:
        Here, we are calculating where the snake's head will move next based on the key pressed.
        For example, if the snake moves up, we subtract from its y position. This is like changing the character's direction in a game.

Part 5: Check for Crashes

python

        # Check if the snake hit the wall or itself
        if (new_head[0] in [0, screen_height] or
            new_head[1] in [0, screen_width] or
            new_head in snake):
            curses.endwin()
            quit()

    Explanation:
        If the snake hits the edge of the screen or runs into itself, the game ends.
        This is like a "Game Over" screen in other video games.

Part 6: Move and Grow the Snake

python

        # Add the new head to the snake
        snake.insert(0, new_head)

    Explanation:
        We add the new head to the front of the snake.
        This makes the snake grow every time it moves forward, just like a train adding more cars.

python

        # Check if the snake has eaten the food
        if snake[0] == food:
            food = None
            while food is None:
                nf = [
                    random.randint(1, screen_height - 2),
                    random.randint(1, screen_width - 2)
                ]
                food = nf if nf not in snake else None
            window.addch(food[0], food[1], curses.ACS_PI)

    Explanation:
        If the snake’s head reaches the food, we generate a new piece of food at a random spot.
        This makes the snake longer and places a new item to collect, just like in other adventure games.

python

        else:
            # Remove the tail of the snake
            tail = snake.pop()
            window.addch(tail[0], tail[1], ' ')

    Explanation:
        If the snake didn’t eat food, we remove the tail. This keeps the snake the same length as it moves.
        This is like the way a character moves forward by leaving behind their old position.

python

        # Draw the snake head
        window.addch(snake[0][0], snake[0][1], curses.ACS_CKBOARD)

    Explanation:
        We draw the new snake head on the screen.
        This is like updating the game graphics to show where the character is now.

Part 7: Run the Game

python

# Run the game
curses.wrapper(snake_game)

    Explanation:
        curses.wrapper(snake_game) starts the game and handles setting up and cleaning up the screen when the game ends.
        It’s like pressing the “Start” button on a game console to launch the game.
