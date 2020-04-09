-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Requirements
local composer = require "composer"

    local physics = require("physics")
    physics.start()

    physics.setGravity( 0, 0 )
    system.activate( "multitouch" )

    -- TESTE RETOMADA DE TELA
    gamemap2 = display.newImageRect("imgs/gamemap2.png", 600, 12000 )
    gamemap2.x = display.contentCenterX
    gamemap2.y = - 5680

    local function onLocalCollision( self, event )
    
        if ( event.phase == "began" ) then
            
    
        elseif ( event.phase == "ended" ) then
            print( self.myName .. ": collision ended with " .. event.other.myName )
        end
    end

    local function movbackground( event )
        gamemap2.y = gamemap2.y + 2
    end

    timerBackground = timer.performWithDelay( 10, movbackground, 0)

    local moto = display.newImageRect("imgs/Motocicleta.png", 40, 90 )
    moto.x = display.contentCenterX
    moto.y = display.contentCenterY
    moto.name = "moto"
    physics.addBody( moto, "dynamic", {radius = 150, bounce=0.3} )

    -- BOTÕES
    local botao = {}

    botao[1] = display.newImageRect("imgs/botao.png", 50, 50 ) --cima
    botao[1].x = 40
    botao[1].y = 210
    botao[1].rotation = -90
    botao[1].myName = "cima"

    botao[2] = display.newImageRect("imgs/botao.png", 50, 50 ) --baixo
    botao[2].x = 45
    botao[2].y = 290
    botao[2].rotation = 90
    botao[2].myName = "baixo"

    botao[3] = display.newImageRect("imgs/botao.png", 50, 50 ) --esquerda
    botao[3].x = 0
    botao[3].y = 250
    botao[3].rotation = -180
    botao[3].myName = "esquerda"

    botao[4] = display.newImageRect("imgs/botao.png", 50, 50 ) --direita
    botao[4].x = 85
    botao[4].y = 245
    botao[4].rotation = 0
    botao[4].myName = "direita"

    local moveX = 0
    local moveY = 0

    local function funcaoToque(e)
        if e.phase == "began" or e.phase == "moved" then
            if e.target.myName == "cima" then
                moveY = -5
                moveX = 0
            elseif  e.target.myName == "baixo" then
                moveY = 5
                moveX = 0
            elseif  e.target.myName == "esquerda" then
                moveY = 0
                moveX = -5
            elseif  e.target.myName == "direita" then
                moveY = 0
                moveX = 5
            end
        else 
            moveX = 0
            moveY = 0
        end
    end

    local j=1

    for j=1, 4, 1 do
        botao[j]:addEventListener( "touch", funcaoToque )
    end

    local function update()
        moto.x = moto.x + moveX
        moto.y = moto.y + moveY
    end

    Runtime:addEventListener("enterFrame", update)

return scene