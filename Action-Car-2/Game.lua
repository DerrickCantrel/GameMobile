local physics = require("physics")
      physics.start()
      physics.setGravity( 0, 0 )
      physics.setDrawMode( "hybrid" )
      system.activate( "multitouch" )

      local sheetOptions =
{
    frames =
    {
        {   -- 1) tank 1
            x = 0,
            y = 0,
            width = 330,
            height = 253
        },
        {   -- 2) tank 2
            x = 0,
            y = 85,
            width = 330,
            height = 253
        },
        {   -- 3) tank 3
            x = 0,
            y = 168,
            width = 330,
            height = 253
        },
    },
}
local objectSheet = graphics.newImageSheet( "imgs/enemys-spri.png", sheetOptions )

-- Requirements
composer = require( "composer" )
cenai = composer.newScene()

-- VARIAVEIS
local score = 0
local Score = 0
local speed = 5
local botao = {}
local moveX = 0
local moveY = 0
local Vel = 7
local died = false
local lives = 1
local tank1
local _W = display.contentWidth
local _H = display.contentHeight
local scrollSpeed = 2
local mapa1
local mapa2
local mapa3
local live3

-- CRIANDO A CENA
function cenai:create(event)

    local grupoCena = self.view

    -- first background
    mapa1 = display.newImageRect("imgs/gamemap.png", 256, 2550)
    mapa1.x = _W*0.5; mapa1.y = _H/2; mapa1.xScale = 2.3;
    mapa1.isVisible = true
    -- mapa1.isVisible = true

    grupoCena:insert(mapa1)

    -- second background
    mapa2 = display.newImageRect("imgs/gamemap.png", 256, 2550)
    mapa2.x = _W*0.5; mapa2.y = mapa1.y + 2550; mapa2.xScale = 2.3;

    grupoCena:insert(mapa2)

    -- third background
    mapa3 = display.newImageRect("imgs/gamemap.png", 256, 2550)
    mapa3.x = _W*0.5; mapa3.y = mapa2.y + 2550; mapa3.xScale = 2.3;

    grupoCena:insert(mapa3)

    -- Resume Botão
    resume = display.newImageRect("imgs/resume.png", 60, 42)
    resume.x = display.contentWidth/2 + 240
    resume.y = 30
    resume.myName="Resume"

    grupoCena:insert(resume)

    -- Limites da via (onCollide)
    limiteLateral1 = display.newRect(100, 160, 20, 320)
    limiteLateral1.alpha = 0
    limiteLateral1.myName="limiteDireito"
    physics.addBody(limiteLateral1, "kinematic", {density=1, friction = .3})

    grupoCena:insert(limiteLateral1)

    limiteLateral2 = display.newRect(400, 160, 20, 320)
    limiteLateral2.alpha = 0
    limiteLateral2.myName="limiteEsquerdo"
    physics.addBody(limiteLateral2, "kinematic", {density=1, friction = .3})

    grupoCena:insert(limiteLateral2)

    -- INIMIGOS
    tank1 = display.newImage("imgs/tank01.png")
    tank1.x = math.random(150, 350); tank1.y = 2000
    tank1:scale(0.3, 0.3)
    tank1.speed = math.random(1,2)
    tank1.myName = "tanklvl1"
    tank1.isVisible = true
    tank1.rotation = -180
    physics.addBody(tank1, "dynamic", {density = .1, radius = 40})

    grupoCena:insert(tank1)

    --tank2 = display.newImage("imgs/tank02.png")
    --tank2.x = math.random(150, 350); tank1.y = 2000
    --tank2:scale(0.4, 0.4)
    --tank2.speed = math.random(1,2)
    --tank2.myName = "tanklvl2"
    --tank2.isVisible = true
    --tank2.rotation = -180
    --physics.addBody(tank2, "dynamic", {density = .1, radius = 40})

    --grupoCena:insert(tank2)

    --tank3 = display.newImage("imgs/tank03.png")
    --tank3.x = math.random(150, 350); tank1.y = 2000
    --tank3:scale(0.4, 0.4)
    --tank3.speed = math.random(1,2)
    --tank3.myName = "tanklvl3"
    --tank3.isVisible = true
    --tank3.rotation = -180
    --physics.addBody(tank3, "dynamic", {density = .1, radius = 40})

    --grupoCena:insert(tank3)

    veiculo = display.newImageRect("imgs/Motocicleta.png", 40, 90 )
    veiculo.x = display.contentCenterX
    veiculo.y = display.contentCenterY
    veiculo.isVisible = true
    veiculo.rotation = 0
    veiculo.myName = "Veiculo"
    physics.addBody( veiculo, "dynamic", {radius = 30, bounce=0.3} )

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

    buttonFire = display.newImageRect("imgs/alvo.png", 81, 81)
    buttonFire.x = 460; buttonFire.y = 250; buttonFire:scale(0.8, 0.8)
    -- buttonFire:addEventListener( "tap", projetilFire)
    grupoCena:insert(buttonFire)

    musicBack = audio.loadStream("sounds/Timecop1983 - On the Run.wav")
    fireSong = audio.loadSound( "sounds/fire.wav" )
end

-- ======================================================================
--                      FUNÇÕES DO GAME
-- ======================================================================
function inimigos(self, event)
    if (self.isVisible == true) then
        if (self.y < -100) then
            self.x = math.random(150, 350); self.y = 2000
        else
            self.y = self.y - self.speed
        end
    end
end

-- função da tela repetindo
local function scroll(event)
    if (mapa1.isVisible == true) then
        mapa1.y = mapa1.y + scrollSpeed
        mapa2.y = mapa2.y + scrollSpeed
        mapa3.y = mapa3.y + scrollSpeed

        if(mapa1.y + mapa1.contentWidth) > 2200 then
            mapa1:translate(0, -5100)
        end
        if(mapa2.y + mapa2.contentWidth) > 2200 then
            mapa2:translate(0, -5100)
        end
        if(mapa3.y + mapa3.contentWidth) > 2200 then
            mapa3:translate(0, -5100)
        end
    end
end

function Contador_func()
    Score = Score + 1

    if (Score == 10000) then
        scrollSpeed = 3
    elseif (Score == 30000) then
        scrollSpeed = 4
    end
end

-- fire button
local function projetilFire()

    audio.play( fireSong )

    local newProjetil = display.newImageRect( "imgs/projetil.png", 12, 27) 
    physics.addBody( newProjetil, "dynamic", { isSensor=true } )
    newProjetil.isBullet = true
    newProjetil.myName = "fire"

    newProjetil.x = veiculo.x
    newProjetil.y = veiculo.y
    newProjetil:toBack()

    transition.to( newProjetil, { y=-40, time=500,
        onComplete = function() display.remove( newProjetil ) end 
    } )
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

function gameOver()
    composer.removeScene( "Resume" )
	composer.gotoScene("Resume", { time=800, effect="crossFade" } ) 
end

-- COLIDIU COM LATERAIS
function onColision(event)
    if (event.phase == "began") then
        if(event.object1.myName == "projetil" and event.object2.myName == "tanklvl1" 
            or event.object1.myName == "tanklvl1" and event.object2.myName == "projetil") 
        then
            display.remove( projetil )

            score = score + 100

        elseif (event.object1.myName == "limiteEsquerdo" and event.object2.myName == "Veiculo" 
            or event.object1.myName == "limiteDireito" and event.object2.myName == "Veiculo") 
        then 
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
                    print("FUI CHAMADOOOOOOOOOOOOOOOOOOOOO")                    display.remove(veiculo) --veiculo:removeSelf()
                    veiculo.isVisible = false
                    display.remove(tank1)
                    display.remove(veiculo)
                    
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
    buttonFire:addEventListener( "tap", projetilFire)
    Runtime:addEventListener("enterFrame", update)



    tank1.enterFrame = inimigos
    Runtime:addEventListener("enterFrame", tank1)

    --tank2.enterFrame = inimigos
    --Runtime:addEventListener("enterFrame", tank2)

    --tank3.enterFrame = inimigos
    --Runtime:addEventListener("enterFrame", --tank3)

    Runtime:addEventListener( "enterFrame", scroll )

    Runtime:addEventListener("enterFrame", Contador_func)
    Runtime:addEventListener("collision", onColision)
    audio.play( musicBack, { channel=1, loops=-1 } )
end

function cenai:hide(event)

    buttonFire:removeEventListener( "tap", projetilFire)
    Runtime:removeEventListener("enterFrame", update)
    Runtime:removeEventListener("enterFrame", Contador_func)

    Runtime:removeEventListener("collision", onColision)
  
end

function cenai:destroy(event)
    local sceneGroup = self.view

    audio.dispose( fireSong )
	audio.dispose( musicBack )
end

cenai:addEventListener("create",cenai)
cenai:addEventListener("show",cenai)
cenai:addEventListener("hide",cenai)
cenai:addEventListener("destroy",cenai)

return cenai