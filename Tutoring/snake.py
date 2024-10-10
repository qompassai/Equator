# Snake Game
# A simple snake game that can be played in the terminal using the keyboard.

import curses
import random

def snake_game(stdscr):
    # Initialize the screen
    curses.curs_set(0)  # Hide the cursor
    screen_height, screen_width = stdscr.getmaxyx()
    window = curses.newwin(screen_height, screen_width, 0, 0)
    window.keypad(1)  # Enable keypad input
    window.timeout(100)  # Refresh every 100 milliseconds

    # Initial position of the snake
    snake_x = screen_width // 4
    snake_y = screen_height // 2
    snake = [
        [snake_y, snake_x],
        [snake_y, snake_x - 1],
        [snake_y, snake_x - 2]
    ]

    # Initial food position
    food = [screen_height // 2, screen_width // 2]
    window.addch(food[0], food[1], curses.ACS_PI)

    # Initial direction of the snake
    key = curses.KEY_RIGHT

    # Start the game loop
    while True:
        # Get the next key pressed
        next_key = window.getch()
        key = key if next_key == -1 else next_key

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

        # Check if the snake hit the wall or itself
        if (new_head[0] in [0, screen_height] or
            new_head[1] in [0, screen_width] or
            new_head in snake):
            curses.endwin()
            quit()

        # Add the new head to the snake
        snake.insert(0, new_head)

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
        else:
            # Remove the tail of the snake
            tail = snake.pop()
            window.addch(tail[0], tail[1], ' ')

        # Draw the snake head
        window.addch(snake[0][0], snake[0][1], curses.ACS_CKBOARD)

# Run the game
curses.wrapper(snake_game)
