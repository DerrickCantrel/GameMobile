local physics = require("physics")
      physics.start()
      physics.setGravity( 0, 0 )
      physics.setDrawMode( "hybrid" )
      system.activate( "multitouch" )


-- Requirements
composer = require( "composer" )
cenai = composer.newScene()

-- VARIAVEIS
Score = 0
speed = 5
botao = {}

-- CRIANDO A CENA
function cenai:create(event)

    local grupoCena = self.view

    mapa = display.newImage("imgs/gamemap.png")
    mapa.x = display.contentWidth/2
    mapa.y = - 950
    mapa.xScale = 2.3--dá uma esticada na imagem na vertical
    mapa.myName="Mapa1"
    print( "contentHeight: ".. display.contentHeight ) --320

    grupoCena:insert(mapa)

    mapacopy = display.newImage("imgs/gamemap.png")
    mapacopy.x = display.contentWidth/2
    mapacopy.y = - 950
    mapacopy.xScale = 2.3 --dá uma esticada na imagem na vertical
    mapacopy.myName="Mapa2"
    print("mapacopy.height".. mapacopy.height)
    print("mapacopy.Y".. mapacopy.y)

    grupoCena:insert(mapacopy)

    -- Resume Botão
    resume = display.newImageRect("imgs/resume.png", 60, 42)
    resume.x = display.contentWidth/2 + 240
    resume.y = 30
    resume.myName="Resume"

    grupoCena:insert(resume)
    
    -- Score + pontos
    scor = display.newText("Score : ",display.contentWidth / 20, 20, native.systemFont, 30)
    scor:setFillColor(0,0,0)
    
    grupoCena:insert(scor)

    pontos = display.newText( Score, 120, 20, native.systemFont, 30 )
    pontos:setFillColor(0,0,255)

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

    -- Limites da via (onCollide)
    limiteHorizontal1 = display.newRect(250, 5, 600, 10)
    limiteHorizontal1.alpha = 0
    limiteHorizontal1.myName="limiteHorizontalC"
    physics.addBody(limiteHorizontal1, "static", {density=1, friction = .3})

    grupoCena:insert(limiteHorizontal1)

    limiteHorizontal2 = display.newRect(250, 320, 600, 20)
    limiteHorizontal2.alpha = 0
    limiteHorizontal2.myName="limiteHorizontalB"
    physics.addBody(limiteHorizontal2, "static", {density=1, friction = .3})

    grupoCena:insert(limiteHorizontal2)

    veiculo = display.newImageRect("imgs/Motocicleta.png", 40, 90 )
    veiculo.x = display.contentCenterX
    veiculo.y = display.contentCenterY
    veiculo.rotation = 0
    veiculo.myName = "Veiculo"
    physics.addBody( veiculo, "dynamic", {radius = 30, bounce=0.3} )

    grupoCena:insert(veiculo)

    -- BOTÕES QUE CONTROLAM A MOTO
    botao[1] = display.newImageRect("imgs/botao.png", 50, 50 ) --cima
    botao[1].x = 40
    botao[1].y = 210
    botao[1].rotation = -90
    botao[1].myName = "cima"

    grupoCena:insert(botao[1])

    botao[2] = display.newImageRect("imgs/botao.png", 50, 50 ) --baixo
    botao[2].x = 45
    botao[2].y = 290
    botao[2].rotation = 90
    botao[2].myName = "baixo"

    grupoCena:insert(botao[2])

    botao[3] = display.newImageRect("imgs/botao.png", 50, 50 ) --esquerda
    botao[3].x = 0
    botao[3].y = 250
    botao[3].rotation = -180
    botao[3].myName = "esquerda"

    grupoCena:insert(botao[3])

    botao[4] = display.newImageRect("imgs/botao.png", 50, 50 ) --direita
    botao[4].x = 85
    botao[4].y = 245
    botao[4].rotation = 0
    botao[4].myName = "direita"

    grupoCena:insert(botao[4])

    local moveX = 0
    local moveY = 0

    function update()
        veiculo.x = veiculo.x + moveX
        veiculo.y = veiculo.y + moveY
    end

-- FUNÇÕES DO GAME
function Contador_func()

    Score = Score + 1
    pontos.text = Score
end

function resumeToque(event) 
    if (event.phase == "began" or event.phase == "moved") then
        print("eaeee")
        if event.target.myName == "Resume" then
            composer.gotoScene("Game", "fade", 800)
        end
    end
end

resume:addEventListener("touch", resumeToque)

-- função da tela repetindo
function move()
    if(veiculo.isVisible) then
            --mapa.y = mapa.y - speed;
        mapa.y = mapa.y + speed;
        --mapacopy.y = mapacopy.y-speed;
        mapacopy.y = mapacopy.y + speed;
        --print("mapa.y ="..mapa.y)
        --print("mapacopy.y ="..mapacopy.y)
        
        --if (mapa.y + mapa.height/2 < 0) then
        if (mapa.y > 1280) then
            --print("mapa.y = "..mapa.y.. " " .. "mapa.height/2=".. mapa.height/2)
            --print("mapa.y: ".. mapa.y.. "mapa.height*3/2=".. mapa.height*3/2)
            --mapa.y = mapa.height*3/2 + speed
                mapa.y = (-940) + speed
            --print("new value mapa:" .. mapa.y)
        elseif (mapacopy.y > 1280) then
            --print("mapacopy.y = "..mapacopy.y.. " " .. "mapa.height/2=".. mapa.height/2)
            --mapacopy.y = mapacopy.height*3/2 - speed
            mapacopy.y = (-945) + speed
            --print("new value mapacopy:" .. mapacopy.y) 
        end
    end
end

-- Aumentando dificuldade (VELOCIDADE)
function VelAumenta()  
    
    
    if(Score > 5000 and Score < 10000)then
    
		  speed = 10
      
      elseif(Score > 10000)then
      
		  speed = 15
      
    end

end

-- Escuta os botoes
function funcaoToque(e)
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

local j=1

for j=1, 4, 1 do
    botao[j]:addEventListener( "touch", funcaoToque )
end

end

-- COLIDOU COM LATERAIS
function onCollisionLaterais(event)
    if (event.phase == "began") then
        if (event.object1.myName == "limiteEsquerdo" and event.object2.myName == "Veiculo" 
            or event.object1.myName == "limiteDireito" and event.object2.myName == "Veiculo") then
            
            Runtime:removeEventListener("enterFrame", update)
            Runtime:removeEventListener("enterFrame", Contador_func)
            Runtime:removeEventListener("enterFrame", VelAumenta)
            Runtime:removeEventListener( "enterFrame", move )
            speed = 0
            Score = 0

            veiculo.isVisible = false
            display.remove(veiculo)
            display.remove(botao[1])
            display.remove(botao[2])
            display.remove(botao[3])
            display.remove(botao[4])
        end
    end 
end

function cenai:show(event)

    Runtime:addEventListener("enterFrame", update)
    Runtime:addEventListener("enterFrame", Contador_func)
    Runtime:addEventListener("enterFrame", VelAumenta)
    Runtime:addEventListener( "enterFrame", move )
    Runtime:addEventListener("collision", onCollisionLaterais)

end

function cenai:hide(event)

    Runtime:removeEventListener("enterFrame", update)
    Runtime:removeEventListener("enterFrame", Contador_func)
    Runtime:removeEventListener("enterFrame", VelAumenta)
    Runtime:removeEventListener( "enterFrame", move )
    Runtime:removeEventListener("collision", onCollisionLaterais)
    Runtime:removeEventListener("enterFrame", resumeToque)
  
end

function cenai:destroy(event)
 
end

cenai:addEventListener("create",cenai)
cenai:addEventListener("show",cenai)
cenai:addEventListener("hide",cenai)
cenai:addEventListener("destroy",cenai)

return cenai
