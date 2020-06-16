local physics = require("physics")
      physics.start()
      physics.setGravity( 0, 0 )
      --physics.setDrawMode( "hybrid" )
      system.activate( "multitouch" )


-- Requirements
composer = require( "composer" )
cenai = composer.newScene()

-- VARIAVEIS
local Score = 0
local speed = 5

local botao = {}
local moveX = 0
local moveY = 0

local died = false
local lives = 3

local _W = display.contentWidth
local _H = display.contentHeight
local scrollSpeed = 2

local mapa1
local mapa2
local mapa3

local function calcSpeed(x1,y1,x2,y2)
    if (level==1) then
        fac = 14
    else
        fac = 7
    end
    local dis = math.sqrt(((x1-x2)^2)+((y1-y2)^2))
    local speed = fac*dis
    return speed
end

function newEnemy(x, y, speed)
    inimigos = inimigos + 1
    local  enemy = display.newImageRect("imgs/tank02.png", 149, 165)
    enemy:scale(0.4, 0.4)
    physics.addBody(enemy, {bounce=0, density=0, radius=(enemy.height*0.4)/2})
    enemy.gravityScale = 0
    enemy.isFixedRotation = true
    enemy.x = x
    enemy.y = y
    function enemy:collision(e)
        if (e.other.class == "Veiculo") then
            inimigos = inimigos - 1
            enemy:removeSelf()
            enemy:removeEventListener("collision", enemy)
            enemy = nil
            tanks = tanks + 1
            caught = true
            change = true
        end
        return true
    end
    enemy:addEventListener("collision", enemy)
    myGroup:insert(enemy)

    local x1 = math.random(260, 350)
    local y1 = math.random(-200, 0)
    local speed1 = calcSpeed(x,y,x1,y1)
    local hurtposx = veiculo.x
    if (x1 < veiculo.x) then
        hurtposx = veiculo.x - 30
    else
        hurtposx = veiculo.x + 30
    end
    local hurtposy = veiculo.y + math.random(-50,20)
    transition.to(enemy,{time=speed1,x=x1,y=y1,onComplete=function()
        transition.to(enemy,{time=speed,x=hurtposx,y=hurtposy,onComplete=function()
            if(enemy~=nil and myGroup~=nil) then
                enemy:removeEventListener("collision",enemy)
                enemy:removeSelf()
                inimigos = inimigos - 1
                enemy = nil
                caught = true
                hurt = true
            end
        end})
    end
    })
end

local function putEnemy(event)
    if (caught == true and stop~=true and inimigos == 0) then
        wave = wave + 1
        nums = nums+1
        for i=1, nums do
            xp = math.random(10,310)
            yp = math.random(10,310)
            newEnemy(xp,yp,calcSpeed(xp,yp,veiculo.x,veiculo.y))
        end
        caught = false
    end
end

-- CRIANDO A CENA
function cenai:create(event)

    local grupoCena = self.view
    myGroup = display.newGroup()
    inimigos = 0
    tanks = 0
    wave = 1
    stop = false
    caught = false
    hurt = false

    -- first background
    mapa1 = display.newImageRect("imgs/gamemap2.png", 256, 10000)
    mapa1.x = _W*0.5; mapa1.y = _H/2; mapa1.xScale = 2.3;
    mapa1.isVisible = true
    -- mapa1.isVisible = true

    grupoCena:insert(mapa1)

    -- second background
    mapa2 = display.newImageRect("imgs/gamemap2.png", 256, 10000)
    mapa2.x = _W*0.5; mapa2.y = mapa1.y + 10000; mapa2.xScale = 2.3;

    grupoCena:insert(mapa2)

    -- third background
    mapa3 = display.newImageRect("imgs/gamemap2.png", 256, 10000)
    mapa3.x = _W*0.5; mapa3.y = mapa2.y + 10000; mapa3.xScale = 2.3;

    grupoCena:insert(mapa3)

    -- Limites da via (onCollide)
    limiteLateral1 = display.newRect(100, 160, 20, 400)
    limiteLateral1.alpha = 0
    limiteLateral1.myName="limiteDireito"
    physics.addBody(limiteLateral1, "kinematic", {density=1, friction = .3})

    grupoCena:insert(limiteLateral1)

    limiteLateral2 = display.newRect(380, 160, 20, 400)
    limiteLateral2.alpha = 0
    limiteLateral2.myName="limiteEsquerdo"
    physics.addBody(limiteLateral2, "kinematic", {density=1, friction = .3})

    grupoCena:insert(limiteLateral2)

    -- INIMIGOS
    tank1 = display.newImage("imgs/tank01.png")
    tank1.x = math.random(150, 350); tank1.y = -400
    tank1:scale(0.4, 0.4)
    tank1.speed = 1
    tank1.myName = "enemy"
    tank1.isVisible = true
    tank1.rotation = 360
    physics.addBody(tank1, "dynamic", {density = .1, radius = 30})

    grupoCena:insert(tank1)

    tank2 = display.newImage("imgs/tank02.png")
    tank2.x = math.random(150, 200); tank2.y = -200
    tank2:scale(0.4, 0.4)
    tank2.speed = 1
    tank2.myName = "enemy"
    tank2.isVisible = true
    tank2.rotation = 360
    physics.addBody(tank2, "dynamic", {density = .1, radius = 30})

    grupoCena:insert(tank2)

    tank3 = display.newImage("imgs/tank03.png")
    tank3.x = math.random(250, 350); tank3.y = math.random(20, 45)
    tank3:scale(0.4, 0.4)
    tank3.speed = 1
    tank3.myName = "enemy"
    tank3.isVisible = true
    tank3.rotation = 360
    physics.addBody(tank3, "dynamic", {density = .1, radius = 30})

    grupoCena:insert(tank3)

    veiculo = display.newImageRect("imgs/Motocicleta.png", 40, 90 )
    veiculo.x = display.contentCenterX
    veiculo.y = 280
    veiculo.isVisible = true
    veiculo.rotation = 0
    veiculo.myName = "Veiculo"
    physics.addBody( veiculo, "dynamic", {radius = 20, bounce=0.3} )

    grupoCena:insert(veiculo)

    -- status vida
    live3 = display.newImage("imgs/life_3.png")
    live3.x = 25; live3.y = 30
    live3:scale(0.7, 0.7)
    live3.isVisible = true

    grupoCena:insert(live3)

    -- status vida
    live2 = display.newImage("imgs/life_2.png")
    live2.x = 25; live2.y = 30
    live2:scale(0.7, 0.7)
    live2.isVisible = false

    grupoCena:insert(live3)

    -- status vida
    live1 = display.newImage("imgs/life_1.png")
    live1.x = 25; live1.y = 30
    live1:scale(0.7, 0.7)
    live1.isVisible = false

    grupoCena:insert(live1)

    -- BOTÕES QUE CONTROLAM A MOTO
    back_botao = display.newImageRect("imgs/bk_controle.png", 700, 500)
    back_botao.x = 48
    back_botao.y = 268
    back_botao:setFillColor(1,1,1)

    grupoCena:insert(back_botao)

    botao[1] = display.newImageRect("imgs/botao.png", 40, 40 ) --cima
    botao[1].x = 40
    botao[1].y = 215
    botao[1].rotation = -90
    botao[1].myName = "cima"
    botao[1].isVisible = true
    botao[1]:setFillColor( 1, 1, 1)

    grupoCena:insert(botao[1])

    botao[2] = display.newImageRect("imgs/botao.png", 40, 40 ) --baixo
    botao[2].x = 45
    botao[2].y = 282
    botao[2].rotation = 90
    botao[2].myName = "baixo"
    botao[2]:setFillColor( 1, 1, 1)

    grupoCena:insert(botao[2])

    botao[3] = display.newImageRect("imgs/botao.png", 40, 40 ) --esquerda
    botao[3].x = 8
    botao[3].y = 250
    botao[3].rotation = -180
    botao[3].myName = "esquerda"
    botao[3]:setFillColor( 1, 1, 1)

    grupoCena:insert(botao[3])

    botao[4] = display.newImageRect("imgs/botao.png", 40, 40 ) --direita
    botao[4].x = 76
    botao[4].y = 246
    botao[4].rotation = 0
    botao[4].myName = "direita"
    botao[4]:setFillColor( 1, 1, 1)

    grupoCena:insert(botao[4])

    scoreStatus = display.newImageRect("imgs/button_bc.png", 300, 90)
    scoreStatus.x = 460
    scoreStatus.y = 30
    scoreStatus:scale(0.4, 0.4)

    grupoCena:insert(scoreStatus)

    scoreText = display.newText(Score, 460, 30, native.systemFont, 26 )
    
    grupoCena:insert(scoreText)

    buttonAtirar = display.newImageRect("imgs/alvo.png", 81, 81)
    buttonAtirar.x = 450; buttonAtirar.y = 280
    
    grupoCena:insert(buttonAtirar)

    Runtime:addEventListener("enterFrame", putEnemy)
    timer.performWithDelay(800, function()
        newEnemy(160,260,4000)
    end,1)

    --musicBack = audio.loadStream("sounds/Timecop1983 - On the Run.wav")
    explosionSound = audio.loadSound( "sounds/explosion.wav" )
    fireSound = audio.loadSound( "sounds/fire.wav" )
    audio.setVolume(1)
end

-- ======================================================================
--                      FUNÇÕES DO GAME
-- ======================================================================

local function inimigos1(self, event)
    self.isVisible = true
    if (tankDied == false and died == false) then
        if (self.y > 400) then
            self.x = math.random(250, 340); self.y = -200 --math.random(20, 45)
            --tankDied = true
        else
            self.y = self.y + self.speed
        end
    else
        tankDied = false 
    end
end

local function inimigos2(self, event)
    self.isVisible = true
    if (tankDied == false and died == false) then
        if (self.y > 500) then
            self.x = math.random(250, 270); self.y = -300 --math.random(20, 45)
            --tankDied = true
        else
            self.y = self.y + self.speed
        end
    else
        tankDied = false 
    end
end

-- função da tela repetindo
local function scroll(event)
    if (mapa1.isVisible == true) then
        mapa1.y = mapa1.y + scrollSpeed
        mapa2.y = mapa2.y + scrollSpeed
        mapa3.y = mapa3.y + scrollSpeed

        if(mapa1.y + mapa1.contentWidth) > 9999 then
            mapa1:translate(0, -20000)
        end
        if(mapa2.y + mapa2.contentWidth) > 9999 then
            mapa2:translate(0, -20000)
        end
        if(mapa3.y + mapa3.contentWidth) > 9999 then
            mapa3:translate(0, -20000)
        end
    end
end

function Contador_func()
    Score = Score + 1
    scoreText.text = Score

    if (Score == 1000) then
        scrollSpeed = 3
    elseif (Score == 20000) then
        scrollSpeed = 5
    end
end

local function restoreVeiculo()

    veiculo.isBodyActive = false
    veiculo.x = display.contentCenterX
    veiculo.y = display.contentCenterY
    
    transition.to( veiculo, { alpha=1, time=3000,
        onComplete = function()
            veiculo.isBodyActive = true
            died = false
        end
    })
end

-- Escuta os botoes
local function funcaoToque(e)
    if e.phase == "began" or e.phase == "moved" then
        if e.target.myName == "cima" then
            print("cima".. moveY)
            moveY = -1
            moveX = 0
        elseif  e.target.myName == "baixo" then
            print("baixo".. moveY)
            moveY = 1
            moveX = 0
        elseif  e.target.myName == "esquerda" then
            print("esquerda" .. moveX)
            moveY = 0
            moveX = -1
        elseif  e.target.myName == "direita" then
            print("direita".. moveX)
            moveY = 0
            moveX = 1
        end
    else 
        moveX = 0
        moveY = 0
    end
end

local function escutaButton()
    if (botao[1].isVisible == true) then
        botao[1]:addEventListener("touch", funcaoToque)
        botao[2]:addEventListener("touch", funcaoToque)
        botao[3]:addEventListener("touch", funcaoToque)
        botao[4]:addEventListener("touch", funcaoToque)
    end  
end

function update()
    if (veiculo.x ~= nil and veiculo.y ~= nil) then
        veiculo.x = veiculo.x + moveX
        veiculo.y = veiculo.y + moveY
    end
end

function fireLaser()
	-- Play fire sound!
	audio.play( fireSound )

	newLaser = display.newImageRect("imgs/projetil.png", 12, 27)
	physics.addBody( newLaser, "dynamic", { isSensor=true } )
	newLaser.isBullet = true
	newLaser.myName = "laser"

	newLaser.x = veiculo.x
	newLaser.y = veiculo.y
	newLaser:toBack()

	transition.to( newLaser, { y=-40, time=500,
		onComplete = function() display.remove( newLaser ) end
	} )
end

function gameOver()
    composer.removeScene( "Resume" )
	composer.gotoScene("Resume", { time=800, effect="crossFade" } ) 
end

-- COLIDIU COM LATERAIS
function onColision(event)
    if (event.phase == "began") then
        local obj1 = event.object1
		local obj2 = event.object2

        if( ( obj1.myName == "Veiculo" and obj2.myName == "enemy") or 
            ( obj1.myName == "enemy" and obj2.myName == "Veiculo") or
            ( obj1.myName == "limiteEsquerdo" and obj2.myName == "Veiculo") or
            ( obj1.myName == "limiteDireito" and obj2.myName == "Veiculo")  )
        then 
            audio.play(explosionSound)
            if ( died == false) then
                died = true

                lives = lives - 1
                print("livesssssssss" .. lives)
                
                if(lives == 2) then
                    live3.isVisible = false
                    display.remove(live3)
                    live2.isVisible = true
                elseif (lives == 1) then
                    live2.isVisible = false
                    display.remove(live2)
                    live1.isVisible = true
                end
                
                if (lives == 0) then
                    print("FUI CHAMADOOOOOOOOOOOOOOOOOOOOO")     
                    display.remove(veiculo) --veiculo:removeSelf()
                    veiculo.isVisible = false
                    display.remove(tank1)
                    display.remove(veiculo)
                    --Runtime:removeEventListener
                    
                    timer.performWithDelay( 2000, gameOver )
                else
                    veiculo.alpha = 0
                    timer.performWithDelay( 1000, restoreVeiculo )
                end
            end
        end
    end
end

function cenai:show(event)

    Runtime:addEventListener("touch", escutaButton)
    Runtime:addEventListener("enterFrame", update)
    buttonAtirar:addEventListener( "tap", fireLaser )

    tank1.enterFrame = inimigos2
    Runtime:addEventListener("enterFrame", tank1)

    tank2.enterFrame = inimigos1
    Runtime:addEventListener("enterFrame", tank2)

    tank3.enterFrame = inimigos2
    Runtime:addEventListener("enterFrame", tank3)

    Runtime:addEventListener( "enterFrame", scroll )

    Runtime:addEventListener("enterFrame", Contador_func)
    Runtime:addEventListener("collision", onColision)
    --audio.play( musicBack, { channel=1, loops=-1 } )
end

function cenai:hide(event)

    Runtime:removeEventListener("enterFrame", update)
    Runtime:removeEventListener("enterFrame", Contador_func)
    Runtime:removeEventListener( "tap", atirarAlvo )
    Runtime:removeEventListener("enterFrame", putEnemy)

    Runtime:removeEventListener("collision", onColision)

  
end

function cenai:destroy(event)
    local sceneGroup = self.view

    audio.dispose( fireSong )
	--audio.dispose( musicBack )
end

cenai:addEventListener("create",cenai)
cenai:addEventListener("show",cenai)
cenai:addEventListener("hide",cenai)
cenai:addEventListener("destroy",cenai)

return cenai