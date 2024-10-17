# Space Invaders 

Congratulations on creating your very own Snake game in Python! That's a fantastic achievement, and you should be super proud of yourself. Now that you've got the basics down, it's time to dive deeper into the exciting world of Python game programming.

This guide is here to help you explore new ideas, learn more about programming, and have tons of fun along the way!


---


Lets take your Python skills to the next level and create an awesome Space Invaders game! 

In this step-by-step guide, we'll build the game together. By the end, you'll have a fun game to play and share with your friends, and you'll have learned a lot about programming along the way!

## Step 1: Create your game making-space

In your home directory (~), make a new folder for your game called `spacegame`. Everything will be done in that folder


```~
mkdir -p spacegame
z spacegame
pwd
```

- `mkdir` is `make directory`
- `pwd` is `print working directory`

- In your spacegame folder, create a new Python file called space_invaders.py and save it in your project folder.

```bash
touch main.py
![](/home/phaedrus/Forge/GH/Qompass/Equator/Tutoring/SpaceInvaders/wget%20https://raw.githubusercontent.com/qompassai/Equator/main/Tutoring/SpaceInvaders/background.png)
```

## Step 2: Install pygame

- Pygame is a python library made for creating simple games.

```bash
pip install pygame
```

**If you get an error, you might need to use pip3 instead of pip.**

---

## Step 3: Start to code, block-by-block

-In your spacegame directory, open the space_invaders.py file with nvim to start coding

```bash
nvim space_invaders.py
```

Step 2: Setting Up the Game Code

Let's break down the code you provided into small steps so that it's easy to understand. You’ll create a file called main.py and add the code step by step. Here is what we will do:

    Set up the game window.
    Add background music and sounds.
    Add a player spaceship.
    Add enemies.
    Add bullets for shooting.
    Show score and game over message.

Step 3: Write the Code

You can start by opening a text editor like VS Code or even a basic editor like Notepad. Save your file as main.py and start adding the following:
1. Import Libraries

```python
import pygame
import random
import math
from pygame import mixer
```
    pygame: This is the main library we are using.
    random: This helps us place enemies randomly.
    math: We'll use this to calculate the distance between the bullet and the enemy.
    mixer: This is used for handling the game's sounds.

2. Initialize Pygame and Create the Game Window

```python

# Initialize pygame
pygame.init()

# Create the screen
screen = pygame.display.set_mode((800, 600))

# Background image
background = pygame.image.load('background.png')

# Background sound
mixer.music.load("background.wav")
mixer.music.play(-1)

# Set the title and icon for the game window
pygame.display.set_caption("Space Invader")
icon = pygame.image.load('ufo.png')
pygame.display.set_icon(icon)
```
    The set_mode((800, 600)) creates an 800x600 pixel window.
    background.png is the image we'll use as the background.
    The music.load and music.play(-1) lines load and loop the background music.


3. Add the Player

```python
# Player image and starting position
playerImg = pygame.image.load('player.png')
playerX = 370
playerY = 480
playerX_change = 0

def player(x, y):
    screen.blit(playerImg, (x, y))
```
    We load player.png as our spaceship image.
    playerX and playerY are the coordinates where the player starts.
    screen.blit() is used to draw the player image at the coordinates (x, y).

4. Add the Enemies

```python

# Enemy image, position, and movement
enemyImg = []
enemyX = []
enemyY = []
enemyX_change = []
enemyY_change = []
num_of_enemies = 6

for i in range(num_of_enemies):
    enemyImg.append(pygame.image.load('enemy.png'))
    enemyX.append(random.randint(0, 736))
    enemyY.append(random.randint(50, 150))
    enemyX_change.append(4)
    enemyY_change.append(40)

def enemy(x, y, i):
    screen.blit(enemyImg[i], (x, y))
```
    We create multiple enemies using lists, so we can have more than one on the screen.
    The enemies are placed randomly along the top part of the screen using random.randint().

5. Add the Bullet

```python
# Bullet image, position, and state
bulletImg = pygame.image.load('bullet.png')
bulletX = 0
bulletY = 480
bulletY_change = 10
bullet_state = "ready"

def fire_bullet(x, y):
    global bullet_state
    bullet_state = "fire"
    screen.blit(bulletImg, (x + 16, y + 10))
```
    The bullet starts in the "ready" state, meaning it's not visible.
    When fired, its state changes to "fire" and it moves upward.

6. Check for Collisions

```python

def isCollision(enemyX, enemyY, bulletX, bulletY):
    distance = math.sqrt(math.pow(enemyX - bulletX, 2) + (math.pow(enemyY - bulletY, 2)))
    if distance < 27:
        return True
    return False
```
    This function calculates the distance between the bullet and the enemy to see if they collide. If the distance is less than 27 pixels, it's a hit!

7. Show Score and Game Over

# Score
```python
score_value = 0
font = pygame.font.Font('freesansbold.ttf', 32)
textX = 10
textY = 10

def show_score(x, y):
    score = font.render("Score : " + str(score_value), True, (255, 255, 255))
    screen.blit(score, (x, y))
# Game over text


```python
over_font = pygame.font.Font('freesansbold.ttf', 64)

def game_over_text():
    over_text = over_font.render("GAME OVER", True, (255, 255, 255))
    screen.blit(over_text, (200, 250))

    We use freesansbold.ttf to draw text on the screen.
    The show_score() function displays the player's score, and game_over_text() displays "GAME OVER" when the player loses.
```

8. Main Game Loop

```python
running = True
while running:
    # Fill screen with black
    screen.fill((0, 0, 0))
    # Draw background image
    screen.blit(background, (0, 0))

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

        # Check if a key is pressed
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_LEFT:
                playerX_change = -5
            if event.key == pygame.K_RIGHT:
                playerX_change = 5
            if event.key == pygame.K_SPACE:
                if bullet_state == "ready":
                    bulletSound = mixer.Sound("laser.wav")
                    bulletSound.play()
                    bulletX = playerX
                    fire_bullet(bulletX, bulletY)

        if event.type == pygame.KEYUP:
            if event.key == pygame.K_LEFT or event.key == pygame.K_RIGHT:
                playerX_change = 0

    # Player movement
    playerX += playerX_change
    if playerX <= 0:
        playerX = 0
    elif playerX >= 736:
        playerX = 736

    # Enemy movement
    for i in range(num_of_enemies):
        # Game Over
        if enemyY[i] > 440:
            for j in range(num_of_enemies):
                enemyY[j] = 2000
            game_over_text()
            break

        enemyX[i] += enemyX_change[i]
        if enemyX[i] <= 0:
            enemyX_change[i] = 4
            enemyY[i] += enemyY_change[i]
        elif enemyX[i] >= 736:
            enemyX_change[i] = -4
            enemyY[i] += enemyY_change[i]

        # Check for collision
        collision = isCollision(enemyX[i], enemyY[i], bulletX, bulletY)
        if collision:
            explosionSound = mixer.Sound("explosion.wav")
            explosionSound.play()
            bulletY = 480
            bullet_state = "ready"
            score_value += 1
            enemyX[i] = random.randint(0, 736)
            enemyY[i] = random.randint(50, 150)

        enemy(enemyX[i], enemyY[i], i)

    # Bullet movement
    if bulletY <= 0:
        bulletY = 480
        bullet_state = "ready"

    if bullet_state == "fire":
        fire_bullet(bulletX, bulletY)
        bulletY -= bulletY_change

    player(playerX, playerY)
    show_score(textX, textY)

    pygame.display.update()

    This loop keeps the game running.
    It checks for user input (key presses) and moves the player or shoots bullets accordingly.
    The enemies move back and forth, and their positions change if they hit the edge of the screen.
    If an enemy reaches a certain point (Y coordinate > 440), the game ends.
```
Step 4: Run Your Game

Save your main.py and run it using:

```
python main.py
```

Now, you have your very own Space Invaders game! This is a great project to help you learn about programming concepts like loops, functions, and basic physics in games.

---

Summary

Congratulations! 🎉 You've just created your own Space Invaders game in Python!

Movement: You learned how to move the player and enemies.

Shooting: You added bullets and firing mechanics.

Collision Detection: You detected when a bullet hits an enemy.

Scoring: You kept track of the player's score.

Game Over: You displayed a game over message when the enemies reach the bottom.


---

Resources

Pygame Documentation: https://www.pygame.org/docs/

Free Sounds: https://freesound.org/

Free Images: https://www.pngguru.com/



---




