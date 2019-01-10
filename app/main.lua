WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

TILE_SIZE = 16
MAX_TILE_X = WINDOW_WIDTH / TILE_SIZE
MAX_TILE_Y = math.floor(WINDOW_HEIGHT / TILE_SIZE)

SNAKE_SPEED = 0.1
snakex, snakey = 1, 1
snakemoving = 'right'
snaketimer = 0
applex1 ,appley1 = 1, 1
applex2 ,appley2 = 1, 1
score = 0

poisionx = {}
poisiony = {}

tilegrid = {}

TILE_EMPTY = 0
TILE_HEAD = 1
TILE_SNAKE = 2
TILE_APPLE = 3
TILE_POISON = 4
function love.load()
    love.window.setTitle('Snake - Harshit') 
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = true
    })
    math.randomseed(os.time())
    initialgrid()

    for i = 1 , 20 do
        poisionx[i] , poisiony[i] = math.random(MAX_TILE_X), math.random(MAX_TILE_Y)
        tilegrid[poisiony[i]][poisionx[i]] = TILE_EMPTY   
    end


end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'left' then
        snakemoving  = 'left'
    elseif key == 'right' then
        snakemoving = 'right'
    elseif key == 'up' then
        snakemoving = 'up'
    elseif key == 'down' then
        snakemoving = 'down'
    end
end

function check_grid ()
    for i = 1 , 50 do
        if tilegrid[poisiony[i]][poisionx[i]] ~= TILE_POISON then
            return true
        end
    end
end

function update_grid ()
    for i = 1 , 50 do
        poisionx[i] , poisiony[i] = math.random(MAX_TILE_X), math.random(MAX_TILE_Y)
        tilegrid[poisiony[i]][poisionx[i]] = TILE_POISON
    end
end  

function love.update(dt)
    if tilegrid[appley1][applex1] ~= TILE_APPLE and tilegrid[appley2][applex2] ~= TILE_APPLE then
        applex , appley = math.random(MAX_TILE_X), math.random(MAX_TILE_Y)
        tilegrid[appley][applex] = TILE_APPLE
        applex2 , appley2 = math.random(MAX_TILE_X), math.random(MAX_TILE_Y)
        tilegrid[appley2][applex2] = TILE_APPLE
        score = score + 1
    end

    x = check_grid()
     
    if x then 
        update_grid()
        score = score - 1
    end

    if score < -2 then
        game_state  = 'lose'
    end
    snaketimer = snaketimer + dt
    if snaketimer >= SNAKE_SPEED then
        if snakemoving == 'right' then
            snakex = snakex + 1
        elseif snakemoving == 'left' then
            snakex = snakex - 1
        elseif snakemoving =='up' then
            snakey =  snakey - 1
        elseif snakemoving == 'down' then
            snakey = snakey + 1
        end
        if (snakex-1)*TILE_SIZE <0 then
            snakex = MAX_TILE_X
        elseif (snakex-1)*TILE_SIZE > WINDOW_WIDTH then
            snakex = 1
        elseif (snakey)*TILE_SIZE > WINDOW_HEIGHT then
            snakey = 1
        elseif (snakey-1)*TILE_SIZE < 0 then
            snakey = MAX_TILE_Y
        end
        snaketimer = 0
        tilegrid[snakey][snakex] = TILE_HEAD
    end
end

function love.draw()
    drawgrid()
    love.graphics.setColor(1,1,0,1)
    love.graphics.print('score : '..tostring(score),WINDOW_WIDTH-10,WINDOW_HEIGHT)     
    if game_state == 'lose' then
        love.graphics.print('GAME - OVER ',WINDOW_WIDTH/2,WINDOW_HEIGHT/2)
        love.event.quit()
    end
end

function drawgrid ()
    
    for y= 1 , MAX_TILE_Y do
        for x = 1 , MAX_TILE_X do
            if tilegrid[y][x] == TILE_EMPTY then
                --love.graphics.setColor(1,1,1,1)            
                --love.graphics.rectangle('line',(x-1)*TILE_SIZE, (y-1)*TILE_SIZE, TILE_SIZE, TILE_SIZE)
            elseif tilegrid[y][x] == TILE_APPLE then
                love.graphics.setColor(1,0,0,1)            
                love.graphics.rectangle('fill',(x-1)*TILE_SIZE, (y-1)*TILE_SIZE, TILE_SIZE, TILE_SIZE)
            elseif tilegrid[y][x] == TILE_HEAD then
                love.graphics.setColor(0,1,0.5,1)
                love.graphics.rectangle('fill',(snakex-1)*TILE_SIZE,(snakey-1)*TILE_SIZE,TILE_SIZE,TILE_SIZE)           
            elseif tilegrid[y][x] == TILE_POISON then
                love.graphics.setColor(0.5,0,0.9,1)            
                love.graphics.rectangle('fill',(x-1)*TILE_SIZE, (y-1)*TILE_SIZE, TILE_SIZE, TILE_SIZE)
            end
        end
    end
end

function drawsnake()
    love.graphics.setColor(0,1,0,1)
    love.graphics.rectangle('fill',(snakex-1)*TILE_SIZE,(snakey-1)*TILE_SIZE,TILE_SIZE,TILE_SIZE)
end

function initialgrid ()
    for y= 1 , MAX_TILE_Y do
        table.insert(tilegrid, {})
        for x = 1 , MAX_TILE_X do
            table.insert(tilegrid[y], TILE_EMPTY)
        end
    end
end