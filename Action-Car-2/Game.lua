local physics = require("physics")
      physics.start()
      physics.setGravity( 0, 0 )
      physics.setDrawMode( "hybrid" )
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
local lives = 1
local died = false
local Vel = 7
local _W = display.contentWidth
local _H = display.contentHeight
local scrollSpeed = 2
local mapa1
local mapa2
local mapa3
local tank1
local veiculo
local musicBack
local resume

-- status vida


-- Score + pontos
scor = display.newText("Score : ",display.contentWidth / 20, 20, native.systemFont, 30)
scor:setFillColor(0,0,0)

--grupoCena:insert(scor)

pontos = display.newText( Score, 120, 20, native.systemFont, 30 )
pontos:setFillColor(1,1,1)

--grupoCena:insert(pontos)

-- Limites da via (onCollide)
limiteLateral1 = display.newRect(100, 160, 20, 320)
limiteLateral1.alpha = 0
limiteLateral1.myName="limiteDireito"
physics.addBody(limiteLateral1, "kinematic", {density=1, friction = .3})

--grupoCena:insert(limiteLateral1)

limiteLateral2 = display.newRect(400, 160, 20, 320)
limiteLateral2.alpha = 0
limiteLateral2.myName="limiteEsquerdo"
physics.addBody(limiteLateral2, "kinematic", {density=1, friction = .3})

--grupoCena:insert(limiteLateral2)

-- Limites da via (onCollide)
limiteHorizontal1 = display.newRect(250, 5, 600, 10)
limiteHorizontal1.alpha = 0
limiteHorizontal1.myName="limiteHorizontalC"
physics.addBody(limiteHorizontal1, "static", {density=1, friction = .3})

--grupoCena:insert(limiteHorizontal1)

limiteHorizontal2 = display.newRect(250, 320, 600, 20)
limiteHorizontal2.alpha = 0
limiteHorizontal2.myName="limiteHorizontalB"
physics.addBody(limiteHorizontal2, "static", {density=1, friction = .3})

--grupoCena:insert(limiteHorizontal2)

--grupoCena:insert(botao[4])

-- ======================================================================
--                      FUNÇÕES DO GAME
-- ======================================================================
local function inimigos(event)
    if (tank1.y < -100) then
        tank1.x = math.random(150, 350); tank1.y = 2000
    else
        tank1.y = tank1.y - tank1.speed
    end
end


-- Atualizando os movimentos dos veiculo
local function Contador_func()
    Score = Score + 1
    pontos.text = Score
end

-- função da tela repetindo
local function scroll(event)
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

-- Aumentando dificuldade (VELOCIDADE)
local function VelAumenta()  
    if(Score > 20000)then
        speed = 7
        
        Vel = 14
    end
end

-- Escuta os botoes
local function funcaoToque(e)
if e.phase == "began" or e.phase == "moved" then
    if e.target.myName == "cima" then
        print("cima")
        moveY = -1
        moveX = 0
    elseif  e.target.myName == "baixo" then
        print("baixo")
        moveY = 1
        moveX = 0
    elseif  e.target.myName == "esquerda" then
        print("esquerda")
        moveY = 0
        moveX = -1
    elseif  e.target.myName == "direita" then
        print("direita")
        moveY = 0
        moveX = 1
    end
else 
    moveX = 0
    moveY = 0
end
end

local function escutaButton()
    botao[1]:addEventListener("touch", funcaoToque)
    botao[2]:addEventListener("touch", funcaoToque)
    botao[3]:addEventListener("touch", funcaoToque)
    botao[4]:addEventListener("touch", funcaoToque)
end

local function update()
    if (veiculo.x ~= nil and veiculo.y ~= nil) then
        veiculo.x = veiculo.x + moveX
        veiculo.y = veiculo.y + moveY
    end
end

local function resumeButton(event) 
    if (event.phase == "began" or event.phase == "moved") then
        print("eaeee")
        if event.target.myName == "Resume" then
            print("olaaaaa")
            GameOver() --criar um restart
        end
    end
end

local function projetilFire()

    audio.play ( fireSong )

    local newProjetil = display.newImageRect("imgs/projetil.png", 12, 27) 
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

local function endGame()
    composer.removeScene( "Resume" )
    composer.gotoScene("Resume", { time=800, effect="crossFade" } )
end

-- COLIDIU COM LATERAIS
local function onCollision(event)

    if (event.phase == "began") then

        local obj1 = event.object1
        local obj2 = event.object2

        if ( ( obj1.myName == "limiteEsquerdo" and obj2.myName == "Veiculo" ) or
            ( obj1.myName == "Veiculo" and obj2.myName == "limiteEsquerdo" ) or
            ( obj1.myName == "limiteDireito" and obj2.myName == "Veiculo" ) or
            ( obj1.myName == "Veiculo" and obj2.myName == "limiteDireito" )
            )
            then
                if ( died == false) then
                    died = true

                    lives = lives - 1
                    
                    if (lives == 0) then
                        display.remove(veiculo) --veiculo:removeSelf()
                        tank1:removeSelf()
                        timer.performWithDelay( 2000, endGame )
                    else
                        veiculo.alpha = 0
                        timer.performWithDelay( 1000, restoreVeiculo )
                    end
                end
        end
    end
end

-- CRIANDO A CENA
function cenai:create(event)

    local grupoCena = self.view

    physics.pause()

    -- Set up display groups
	backGroup = display.newGroup()  -- Display group for the background image
	grupoCena:insert( backGroup )  -- Insert into the scene's view group

	mainGroup = display.newGroup()  -- Display group for the ship, asteroids, lasers, etc.
	grupoCena:insert( mainGroup )  -- Insert into the scene's view group

	uiGroup = display.newGroup()    -- Display group for UI objects like the score
    grupoCena:insert( uiGroup )    -- Insert into the scene's view group
    
    -- first background
    mapa1 = display.newImageRect("imgs/gamemap.png", 256, 2550)
    mapa1.x = _W*0.5; mapa1.y = _H/2; mapa1.xScale = 2.3;

    --grupoCena:insert(mapa1)

    -- second background
    mapa2 = display.newImageRect("imgs/gamemap.png", 256, 2550)
    mapa2.x = _W*0.5; mapa2.y = mapa1.y + 2550; mapa2.xScale = 2.3;

    --grupoCena:insert(mapa2)

    -- third background
    mapa3 = display.newImageRect("imgs/gamemap.png", 256, 2550)
    mapa3.x = _W*0.5; mapa3.y = mapa2.y + 2550; mapa3.xScale = 2.3;
    

    -- BOTÕES QUE CONTROLAM A MOTO
    back_botao = display.newImageRect("imgs/bk_controle.png", 700, 500)
    back_botao.x = 48
    back_botao.y = 268
    back_botao:setFillColor(1,1,1)

    --grupoCena:insert(back_botao)

    botao[1] = display.newImageRect("imgs/botao.png", 40, 40 ) --cima
    botao[1].x = 40
    botao[1].y = 215
    botao[1].rotation = -90
    botao[1].myName = "cima"
    botao[1]:setFillColor( 1, 1, 1)

    --grupoCena:insert(botao[1])

    botao[2] = display.newImageRect("imgs/botao.png", 40, 40 ) --baixo
    botao[2].x = 45
    botao[2].y = 282
    botao[2].rotation = 90
    botao[2].myName = "baixo"
    botao[2]:setFillColor( 1, 1, 1)

    --grupoCena:insert(botao[2])

    botao[3] = display.newImageRect("imgs/botao.png", 40, 40 ) --esquerda
    botao[3].x = 8
    botao[3].y = 250
    botao[3].rotation = -180
    botao[3].myName = "esquerda"
    botao[3]:setFillColor( 1, 1, 1)

    --grupoCena:insert(botao[3])

    botao[4] = display.newImageRect("imgs/botao.png", 40, 40 ) --direita
    botao[4].x = 76
    botao[4].y = 246
    botao[4].rotation = 0
    botao[4].myName = "direita"
    botao[4]:setFillColor( 1, 1, 1)

        -- INIMIGOS
    tank1 = display.newImage("imgs/tank01.png")
    tank1.x = math.random(150, 350); tank1.y = 2000
    tank1:scale(0.4, 0.4)
    tank1.speed = math.random(1,2)
    tank1.myName = "tanklvl1"
    tank1.rotation = -180
    physics.addBody(tank1, "static", {density = .1, radius = 40})

    veiculo = display.newImageRect("imgs/Motocicleta.png", 40, 90 )
    veiculo.x = display.contentCenterX
    veiculo.y = display.contentCenterY
    veiculo.rotation = 0
    veiculo.myName = "Veiculo"
    physics.addBody( veiculo, "dynamic", {radius = 30, bounce=0.3} )

    -- Resume Botão
    resume = display.newImageRect("imgs/resume.png", 60, 42)
    resume.x = display.contentWidth/2 + 240; resume.y = 30
    resume.myName="Resume"

    --grupoCena:insert(veiculo)

    buttonFire = display.newImageRect("imgs/alvo.png", 81, 81)
    buttonFire.x = 460; buttonFire.y = 250
    buttonFire:addEventListener( "tap", projetilFire)


    musicBack = audio.loadStream("sounds/Nightcall - Instrumental.wav")
end

function cenai:show(event)
    Runtime:addEventListener("touch", escutaButton)
    Runtime:addEventListener("enterFrame", update)
    Runtime:addEventListener("enterFrame", inimigos)
    Runtime:addEventListener("enterFrame", Contador_func)
    Runtime:addEventListener("enterFrame", VelAumenta)
    Runtime:addEventListener( "enterFrame", scroll )
    Runtime:addEventListener("collision", onCollision)
    Runtime:addEventListener("enterFrame", resumeButton)
    audio.play( musicBack, { channel=1, loops=-1 } )
end

function cenai:hide(event)
    Runtime:removeEventListener("enterFrame", inimigos)
    Runtime:removeEventListener("touch", escutaButton)
    Runtime:removeEventListener("enterFrame", update)
    Runtime:removeEventListener("enterFrame", Contador_func)
    Runtime:removeEventListener("enterFrame", VelAumenta)
    Runtime:removeEventListener( "enterFrame", scroll )
    Runtime:removeEventListener("collision", onCollision)
    Runtime:removeEventListener("enterFrame", resumeButton)
  
end

function cenai:destroy(event)

    audio.dispose( musicBack )
end

cenai:addEventListener("create",cenai)
cenai:addEventListener("show",cenai)
cenai:addEventListener("hide",cenai)
cenai:addEventListener("destroy",cenai)

return cenai
