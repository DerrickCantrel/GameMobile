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
moveX = 0
moveY = 0
life = 3
Vel = 7

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

    -- status vida
    vida3 = display.newImageRect("imgs/life_3.png", 100, 50)
    vida3.x = display.contentWidth/2 - 220
    vida3.y = 30
    vida3.isVisible = true

    grupoCena:insert(vida3)

    vida2 = display.newImageRect("imgs/life_1.png", 100, 50)
    vida2.x = display.contentWidth/2 - 220
    vida2.y = 30
    vida2.isVisible = false

    grupoCena:insert(vida2)

    vida1 = display.newImageRect("imgs/life_1.png", 100, 50)
    vida1.x = display.contentWidth/2 - 220
    vida1.y = 30
    vida1.isVisible = false

    grupoCena:insert(vida1)

    -- Score + pontos
    scor = display.newText("Score : ",display.contentWidth / 20, 20, native.systemFont, 30)
    scor:setFillColor(0,0,0)
    
    grupoCena:insert(scor)

    pontos = display.newText( Score, 120, 20, native.systemFont, 30 )
    pontos:setFillColor(1,1,1)

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

    -- INIMIGOS
    tank1 = display.newImageRect("imgs/tank01.png", 75, 60)
    tank1.myName = "tanklvl1"
    tank1.x = 400
    tank1.y = 260
    physics.addBody(tank1, "kinematic", {density = 0.1, radius = 40})

    grupoCena:insert(tank1)

    veiculo = display.newImageRect("imgs/Motocicleta.png", 40, 90 )
    veiculo.x = display.contentCenterX
    veiculo.y = display.contentCenterY
    veiculo.rotation = 0
    veiculo.myName = "Veiculo"
    physics.addBody( veiculo, "dynamic", {radius = 30, bounce=0.3} )

    grupoCena:insert(veiculo)

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
end

-- ======================================================================
--                      FUNÇÕES DO GAME
-- ======================================================================
function inimigos()
    if (Score >= 1000) then
        if (tank1.y <= - 200) then
            tank1.y = math.random(1200, 5000)
            else
            tank1.y = tank1.y - Vel
        end
    end
end

-- Atualizando os movimentos dos veiculo
function Contador_func()
    Score = Score + 1
    pontos.text = Score
end

-- função da tela repetindo
function move()
        mapa.y = mapa.y + speed;
        mapacopy.y = mapacopy.y + speed;
        if (mapa.y > 1280) then
                mapa.y = (-940) + speed
        elseif (mapacopy.y > 1280) then
            mapacopy.y = (-945) + speed
        end
end

-- Aumentando dificuldade (VELOCIDADE)
function VelAumenta()  
    if(Score > 20000)then
          speed = 7
          
          Vel = 14
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

function escutaButton()
    botao[1]:addEventListener("touch", funcaoToque)
    botao[2]:addEventListener("touch", funcaoToque)
    botao[3]:addEventListener("touch", funcaoToque)
    botao[4]:addEventListener("touch", funcaoToque)
end

function update()
    if (veiculo.x ~= nil and veiculo.y ~= nil) then
        veiculo.x = veiculo.x + moveX
        veiculo.y = veiculo.y + moveY
    end
end

function resumeButton(event) 
    if (event.phase == "began" or event.phase == "moved") then
        print("eaeee")
        if event.target.myName == "Resume" then
            print("olaaaaa")
            endGame()
            GameOver() --criar um restart
        end
    end
end

function GameOver()
	composer.gotoScene("Resume","fade",800) 
end

function endGame()
    Runtime:removeEventListener("enterFrame", update)
    Runtime:removeEventListener("touch", escutaButton)
    Runtime:removeEventListener("enterFrame", Contador_func)
    Runtime:removeEventListener("enterFrame", VelAumenta)
    Runtime:removeEventListener( "enterFrame", move )
    Runtime:removeEventListener("enterFrame", Contador_func)
    speed = 5
    Score = 0

    veiculo.isVisible = false
    --display.remove(veiculo)
    --display.remove(botao[1])
    --display.remove(botao[2])
    --display.remove(botao[3])
    --display.remove(botao[4])
    display.remove(scor)
    display.remove(pontos) -- n resolve, pontos em 2 instancia
end

-- COLIDIU COM LATERAIS
function onCollisionLaterais(event)
    if (event.phase == "began") then
        if (event.object1.myName == "limiteEsquerdo" and event.object2.myName == "Veiculo" 
            or event.object1.myName == "limiteDireito" and event.object2.myName == "Veiculo") then 

            print("funcionaaaaaaaaaaaaaaaaaaaa")
            Runtime:removeEventListener("touch", escutaButton)
            Runtime:removeEventListener("enterFrame", update)
            Runtime:removeEventListener("enterFrame", Contador_func)
            speed = 5
            Score = 0
            Runtime:removeEventListener("enterFrame", VelAumenta)
            Runtime:removeEventListener( "enterFrame", move )
            

            --veiculo.isVisible = false
            --display.remove(veiculo)

            --Remove o objeto de exibição e libera sua memória
            veiculo:removeSelf()
            scor.isVisible = false -- TESTE

            --for j=1, 4, 1 do
                --botao[j]:removeSelf()
            --end

            timer.performWithDelay(2000,GameOver,1) 
        end
    end
end

function cenai:show(event)
    Runtime:addEventListener("touch", escutaButton)
    Runtime:addEventListener("enterFrame", update)
    Runtime:addEventListener("enterFrame", inimigos)
    Runtime:addEventListener("enterFrame", Contador_func)
    Runtime:addEventListener("enterFrame", VelAumenta)
    Runtime:addEventListener( "enterFrame", move )
    Runtime:addEventListener("collision", onCollisionLaterais)
    Runtime:addEventListener("enterFrame", resumeButton)

end

function cenai:hide(event)
    Runtime:removeEventListener("touch", escutaButton)
    Runtime:removeEventListener("enterFrame", update)
    Runtime:removeEventListener("enterFrame", Contador_func)
    Runtime:removeEventListener("enterFrame", VelAumenta)
    Runtime:removeEventListener( "enterFrame", move )
    Runtime:removeEventListener("collision", onCollisionLaterais)
    Runtime:removeEventListener("enterFrame", resumeButton)
  
end

function cenai:destroy(event)
 
end

cenai:addEventListener("create",cenai)
cenai:addEventListener("show",cenai)
cenai:addEventListener("hide",cenai)
cenai:addEventListener("destroy",cenai)

return cenai
