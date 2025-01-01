_G.love = require("love")

-- hra a její vlastnosti
_G.game = {
    difficulty = 1,
    state = {
        menu = false,
        paused = false,
        running = true,
        ended = false
    }
}

-- králík a jeho vlastnosti
_G.rabbit = {
    x = 0,
    y = 0,
    sprite = {
        sprite = love.graphics.newImage("sprites/spritesheet.png"),
        sprite_width = 192,
        sprite_height = 128,
        quad_width = 48,
        quad_height = 32
    },
    animation = {
        direction = "left",
        idle = false,
        frame = 1,
        max_frames = 4,
        speed = 10,
        timer = 0.1
    }
}

-- hráč a jeho vlastnosti
_G.player = {
    radius = 10,
    x = 20,
    y = 20
}

_G.quads = {}

function love.load()
    love.window.setTitle("The rabbit game")
    love.mouse.setVisible(false) -- oddělání kursoru

    for i = 1, rabbit.animation.max_frames do
        quads[i] = love.graphics.newQuad(rabbit.sprite.quad_width * (i - 1), 0, rabbit.sprite.quad_width,
            rabbit.sprite.quad_height, rabbit.sprite.sprite_width, rabbit.sprite.sprite_height)
    end
end

function love.update(dt)
    player.x, player.y = love.mouse.getPosition()

    -- kontrola stisku kláves pro pohyb  králíka
    if love.keyboard.isDown("d") then
        rabbit.animation.idle = false
        rabbit.animation.direction = "right"
    else
        if love.keyboard.isDown("a") then
            rabbit.animation.idle = false
            rabbit.animation.direction = "left"
        else
            rabbit.animation.idle = true
            rabbit.animation.frame = 1
        end
    end

    -- aktualizace animace při pohybu králíka
    if not rabbit.animation.idle then
        rabbit.animation.timer = rabbit.animation.timer + dt

        if rabbit.animation.timer > 0.2 then
            rabbit.animation.timer = 0.1

            rabbit.animation.frame = rabbit.animation.frame + 1

            if rabbit.animation.direction == "right" then
                rabbit.x = rabbit.x + rabbit.animation.speed
            elseif rabbit.animation.direction == "left" then
                rabbit.x = rabbit.x - rabbit.animation.speed
            end

            if rabbit.animation.frame > rabbit.animation.max_frames then
                rabbit.animation.frame = 1
            end
        end
    end
end

function love.draw()
    if game.state["running"] then
        -- vykreslení bílého kruhu pro hráče
        love.graphics.circle("fill", player.x, player.y, player.radius)

        -- vykreslení králíka pro pohyb vpravo (zrcadlově)
        if rabbit.animation.direction == "right" then
            love.graphics.draw(rabbit.sprite.sprite, quads[rabbit.animation.frame], rabbit.x, rabbit.y, 0, -1, 1,
                rabbit.sprite.quad_width, 0)
        else
            love.graphics.draw(rabbit.sprite.sprite, quads[rabbit.animation.frame], rabbit.x, rabbit.y)
        end
    end

    if not game.state["running"] then
        love.graphics.circle("fill", player.x, player.y, player.radius / 2)
    end
end
