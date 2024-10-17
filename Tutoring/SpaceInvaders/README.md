# Space Invaders 

Congratulations on creating your very own Snake game in Python! That's a fantastic achievement, and you should be super proud of yourself. Now that you've got the basics down, it's time to dive deeper into the exciting world of Python game programming.

This guide is here to help you explore new ideas, learn more about programming, and have tons of fun along the way!


---


Lets take your Python skills to the next level and create an awesome Space Invaders game! 

In this step-by-step guide, we'll build the game together. By the end, you'll have a fun game to play and share with your friends, and you'll have learned a lot about programming along the way!

Step 1: Create your game making-space

First, we need to install the Pygame library, which will help us create games with graphics and sound.

1. In your home directory (~), make a new folder for your game called `spacegame`. Everything will be done in that folder

```~
mkdir -p spacegame
z spacegame
pwd
```

- `mkdir` is `make directory`
- `pwd` is `print working directory`

2. Install pygame

- Pygame is a python library made for creating simple games.

```bash
pip install pygame
```

**If you get an error, you might need to use pip3 instead of pip.**

--

Step 2: Lets build our Rocketship

3. In our spacegame folder, create a new Python file called rocket.py and save it in your project folder.

- Each 

---

Step 3: Import Libraries

At the top of your spacegame.py file, we need to import the libraries we'll use.


```block_1
import pygame
import random
import math
from pygame import mixer
```

## Block 1 

```Explanation

pygame: The main library for creating the game.

random: To place enemies at random positions.

math: For calculating distances.

mixer: For adding sound effects.
```


---

Block 2: Initialize Pygame

# Initialize the pygame
pygame.init()


---

Step 5: Create the Game Window

# Create the screen
screen = pygame.display.set_mode((800, 600))

We set the width to 800 pixels and the height to 600 pixels.


Set the Title and Icon

# Title and Icon
pygame.display.set_caption("Space Invaders")
icon = pygame.image.load('ufo.png')
pygame.display.set_icon(icon)

You'll need an image named ufo.png in your project folder for the icon.



---

Step 6: Add Background Image

# Background Image
background = pygame.image.load('background.png')

You'll need a background.png image for the game's background.



---

Step 7: Background Music

# Background Sound
mixer.music.load('background.wav')
mixer.music.play(-1)

You'll need a background.wav sound file.

The -1 makes the music loop indefinitely.



---

Step 8: Create the Player

Load Player Image and Set Starting Position

# Player
playerImg = pygame.image.load('player.png')
playerX = 370
playerY = 480
playerX_change = 0

You'll need a player.png image for the player's spaceship.


Draw the Player

def player(x, y):
    screen.blit(playerImg, (x, y))

screen.blit draws the image on the screen at coordinates (x, y).



---

Step 9: Create the Enemy

Load Enemy Image and Set Starting Position

# Enemy
enemyImg = []
enemyX = []
enemyY = []
enemyX_change = []
enemyY_change = []
num_of_enemies = 6

for i in range(num_of_enemies):
    enemyImg.append(pygame.image.load('enemy.png'))
    enemyX.append(random.randint(0, 735))
    enemyY.append(random.randint(50, 150))
    enemyX_change.append(4)
    enemyY_change.append(40)

You'll need an enemy.png image for the enemy.

We create multiple enemies using lists.


Draw the Enemy

def enemy(x, y, i):
    screen.blit(enemyImg[i], (x, y))


---

Step 10: Create the Bullet

Load Bullet Image and Set Initial State

# Bullet

# Ready - You can't see the bullet on the screen
# Fire - The bullet is moving

bulletImg = pygame.image.load('bullet.png')
bulletX = 0
bulletY = 480
bulletX_change = 0
bulletY_change = 10
bullet_state = "ready"

You'll need a bullet.png image.

The bullet starts in a "ready" state.


Fire the Bullet

def fire_bullet(x, y):
    global bullet_state
    bullet_state = "fire"
    screen.blit(bulletImg, (x + 16, y + 10))


---

Step 11: Collision Detection

We need to check if the bullet hits the enemy.

def isCollision(enemyX, enemyY, bulletX, bulletY):
    distance = math.sqrt((math.pow(enemyX - bulletX, 2)) + (math.pow(enemyY - bulletY, 2)))
    if distance < 27:
        return True
    else:
        return False


---

Step 12: Display the Score

# Score

score_value = 0
font = pygame.font.Font('freesansbold.ttf', 32)

textX = 10
textY = 10

def show_score(x, y):
    score = font.render("Score : " + str(score_value), True, (255, 255, 255))
    screen.blit(score, (x, y))


---

Step 13: Game Over Text

# Game Over
over_font = pygame.font.Font('freesansbold.ttf', 64)

def game_over_text():
    over_text = over_font.render("GAME OVER", True, (255, 255, 255))
    screen.blit(over_text, (200, 250))


---

Step 14: The Game Loop

This is where everything comes together!

# Game Loop
running = True
while running:

    # RGB = Red, Green, Blue
    screen.fill((0, 0, 0))
    # Background Image
    screen.blit(background, (0, 0))

    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False

        # If keystroke is pressed check whether it's right or left
        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_LEFT:
                playerX_change = -5
            if event.key == pygame.K_RIGHT:
                playerX_change = 5
            if event.key == pygame.K_SPACE:
                if bullet_state == "ready":
                    bullet_Sound = mixer.Sound('laser.wav')
                    bullet_Sound.play()
                    # Get the current x coordinate of the spaceship
                    bulletX = playerX
                    fire_bullet(bulletX, bulletY)

        if event.type == pygame.KEYUP:
            if event.key == pygame.K_LEFT or event.key == pygame.K_RIGHT:
                playerX_change = 0

    # Checking for boundaries of spaceship so it doesn't go out of bounds
    playerX += playerX_change
    if playerX <= 0:
        playerX = 0
    elif playerX >= 736:
        playerX = 736

    # Enemy Movement
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

        # Collision
        collision = isCollision(enemyX[i], enemyY[i], bulletX, bulletY)
        if collision:
            explosion_Sound = mixer.Sound('explosion.wav')
            explosion_Sound.play()
            bulletY = 480
            bullet_state = "ready"
            score_value += 1
            enemyX[i] = random.randint(0, 735)
            enemyY[i] = random.randint(50, 150)

        enemy(enemyX[i], enemyY[i], i)

    # Bullet Movement
    if bulletY <= 0:
        bulletY = 480
        bullet_state = "ready"

    if bullet_state == "fire":
        fire_bullet(bulletX, bulletY)
        bulletY -= bulletY_change

    player(playerX, playerY)
    show_score(textX, textY)
    pygame.display.update()


---

Step 15: Add Sound Effects

Make sure you have the following sound files in your project folder:

laser.wav for the bullet firing.

explosion.wav for when an enemy is hit.



---

Step 16: Run Your Game!

Save your space_invaders.py file and run it. You should see your game window open, and you can move the spaceship left and right using the arrow keys and fire bullets using the spacebar.


---

Summary

Congratulations! 🎉 You've just created your own Space Invaders game in Python!

Movement: You learned how to move the player and enemies.

Shooting: You added bullets and firing mechanics.

Collision Detection: You detected when a bullet hits an enemy.

Scoring: You kept track of the player's score.

Game Over: You displayed a game over message when the enemies reach the bottom.



---

What's Next?

Customize the Game: Change images, add more enemies, or make the game harder.

Add Levels: Increase the speed of enemies as the player scores more points.

Improve Graphics: Design your own sprites or use more advanced graphics.



---

Tips

Keep Practicing: The more you code, the better you'll get.

Experiment: Don't be afraid to change the code and see what happens.

Have Fun: Enjoy the process of creating and learning.



---

Resources

Pygame Documentation: https://www.pygame.org/docs/

Free Sounds: https://freesound.org/

Free Images: https://www.pngguru.com/



---

Happy coding! If you have any questions or need help, feel free to ask. Enjoy your game! 🚀🎮


