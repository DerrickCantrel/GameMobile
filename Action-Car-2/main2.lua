local physics = require("physics")
      physics.start()
      physics.setGravity(0, 0)
      physics.setDrawMode( "hybrid" )
      system.activate( "multitouch" )
      
Score = 0
speed = 5

    mapa = display.newImage("imgs/gamemap.png")
    mapa.x = display.contentWidth/2
    mapa.y = - 950
    mapa.xScale = 2.3--dá uma esticada na imagem na vertical
    print( "contentHeight: ".. display.contentHeight ) --320

    --grupoCena:insert(gamemap)

    mapacopy = display.newImage("imgs/gamemap.png")
    mapacopy.x = display.contentWidth/2
    mapacopy.y = - 950
    mapacopy.xScale = 2.3 --dá uma esticada na imagem na vertical
    print("mapacopy.height".. mapacopy.height)
    print("mapacopy.Y".. mapacopy.y)
    
    -- Score + pontos
    scor = display.newText("Score : ",display.contentWidth / 20, 20, native.systemFont, 30)
    scor:setFillColor(0,0,0)
    
    -- grupoCena:insert(Dist)

    pontos = display.newText( Score, 120, 20, native.systemFont, 30 )
    pontos:setFillColor(0,0,255)

    -- Limites da via (onCollide)
    limiteLateral1 = display.newRect(100, 160, 20, 320)
    limiteLateral1.alpha = 0
    limiteLateral1.Myname="limiteDireito"
    physics.addBody(limiteLateral1, "kinematic", {density=1, friction = .3})

    --grupoCena:insert(limiteLateral1)

    limiteLateral2 = display.newRect(400, 160, 20, 320)
    limiteLateral2.alpha = 0
    limiteLateral2.Myname="limiteEsquerdo"
    physics.addBody(limiteLateral2, "kinematic", {density=1, friction = .3})

    -- Limites da via (onCollide)
    limiteHorizontal1 = display.newRect(250, 5, 600, 10)
    limiteHorizontal1.alpha = 0
    limiteHorizontal1.Myname="limiteHorizontalC"
    physics.addBody(limiteHorizontal1, "static", {density=1, friction = .3})

    --grupoCena:insert(limiteLateral1)

    limiteHorizontal2 = display.newRect(250, 320, 600, 20)
    limiteHorizontal2.alpha = 0
    limiteHorizontal2.Myname="limiteHorizontalB"
    physics.addBody(limiteHorizontal2, "static", {density=1, friction = .3})

    veiculo = display.newImageRect("imgs/Motocicleta.png", 40, 90 )
    veiculo.x = display.contentCenterX
    veiculo.y = display.contentCenterY
    veiculo.rotation = 0
    veiculo.myName = "Veiculo"
    physics.addBody( veiculo, "dynamic", {radius = 30, bounce=0.3} )

    -- BOTÕES QUE CONTROLAM A MOTO
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

    function update()
        veiculo.x = veiculo.x + moveX
        veiculo.y = veiculo.y + moveY
    end
    
function Contador_func()

    Score = Score + 1
    pontos.text = Score
end

-- função da tela repetindo
function move()
    if(veiculo.isVisible) then
            --mapa.y = mapa.y - speed;
        mapa.y = mapa.y + speed;
        --mapacopy.y = mapacopy.y-speed;
        mapacopy.y = mapacopy.y + speed;
        print("mapa.y ="..mapa.y)
        print("mapacopy.y ="..mapacopy.y)
        
        --if (mapa.y + mapa.height/2 < 0) then
        if (mapa.y > 1280) then
            --print("mapa.y = "..mapa.y.. " " .. "mapa.height/2=".. mapa.height/2)
            --print("mapa.y: ".. mapa.y.. "mapa.height*3/2=".. mapa.height*3/2)
            --mapa.y = mapa.height*3/2 + speed
                mapa.y = (-940) + speed
            print("new value mapa:" .. mapa.y)
        elseif (mapacopy.y > 1280) then
            --print("mapacopy.y = "..mapacopy.y.. " " .. "mapa.height/2=".. mapa.height/2)
            --print("mapacopy.y: ".. mapacopy.y.. "mapacopy.height*3/2=".. mapacopy.height*3/2)
            --mapacopy.y = mapacopy.height*3/2 - speed
            mapacopy.y = (-945) + speed
            print("new value mapacopy:" .. mapacopy.y) end
    end
end

-- Aumentando dificuldade (VELOCIDADE)
function VelAumenta()  
    
    
    if(Score > 5000 and Score < 1500)then
    
		  speed = 10
      
      elseif(Score > 1500 and Score < 3000)then
      
		  speed = 15
      
      elseif(Score > 3000)then
      
		  speed = 20
      
    end

end

function funcaoToque(e)
    if e.phase == "began" or e.phase == "moved" then
        if e.target.myName == "cima" then
            print("cima")
            moveY = -5
            moveX = 0
        elseif  e.target.myName == "baixo" then
            print("baixo")
            moveY = 5
            moveX = 0
        elseif  e.target.myName == "esquerda" then
            print("esquerda")
            moveY = 0
            moveX = -5
        elseif  e.target.myName == "direita" then
            print("direita")
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

-- COLIDOU COM LATERAIS
function onCollisionLaterais(event)
    if (event.phase == "began") then
        if (event.object1.myName == "limiteEsquerdo" or event.object2.myName == "Veiculo" or event.object1.myName == "limiteDireito" and event.object2.myName == "Veiculo") then
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

Runtime:addEventListener("enterFrame", update)
Runtime:addEventListener("enterFrame", Contador_func)
Runtime:addEventListener("enterFrame", VelAumenta)
Runtime:addEventListener( "enterFrame", move )
Runtime:addEventListener("collision", onCollisionLaterais)