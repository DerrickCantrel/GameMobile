local physics = require("physics")
      physics.start()
      physics.setGravity( 0, 0 )
      physics.setDrawMode( "hybrid" )
      system.activate( "multitouch" )


-- Requirements
composer = require( "composer" )
cenag = composer.newScene()

-- VARIAVEIS
Velocidade = 5
C1W = 569 + display.contentWidth/2

-- CRIANDO A CENA
function cenag:create(event)

    local grupoCena = self.view

    -- TELA REPEAT

    mapa = display.newImageRect("imgs/gamemap.png", 600, 2550 )
    mapa.x = display.contentCenterX
    mapa.y = - 5680

    grupoCena:insert(gamemap)

    mapacopy = display.newImageRect("imgs/gamemap.png", 600, 2550 )
    mapacopy.x = display.contentCenterX
    mapacopy.y = - 5680

    grupoCena:insert(mapacopy)

    --[[
    -- TESTE RETOMADA DE TELA
    gamemap2 = display.newImageRect("imgs/gamemap2.png", 600, 12000 )
    gamemap2.x = display.contentCenterX
    gamemap2.y = - 5680
    

    grupoCena.insert(gamemap2)
    ]]--

    -- Limites da via (onCollide)
    limiteLateral1 = display.newRect(100, 160, 20, 320)
    limiteLateral1.alpha = 0
    limiteLateral1.Myname="limiteDireito"
    physics.addBody(limiteLateral1, "static", {density=1, friction = .3})

    grupoCena:insert(limiteLateral1)

    limiteLateral2 = display.newRect(400, 160, 20, 320)
    limiteLateral2.alpha = 0
    limiteLateral2.Myname="limiteEsquerdo"
    physics.addBody(limiteLateral2, "static", {density=1, friction = .3})

    grupoCena:insert(limiteLateral2)

    --[[
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
    ]]--

    veiculo = display.newImageRect("imgs/Motocicleta.png", 40, 90 )
    veiculo.x = display.contentCenterX
    veiculo.y = display.contentCenterY
    veiculo.rotation = 0
    veiculo.myName = "Veiculo"
    physics.addBody( veiculo, "dynamic", {radius = 30, bounce=0.3} )

    p:play()

    grupoCena:insert(veiculo)

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

    grupoCena:insert(botao[1])
    grupoCena:insert(botao[2])
    grupoCena:insert(botao[3])
    grupoCena:insert(botao[4])


end

--####################################################################
--Fun��es auxiliares
--####################################################################
--####################################################################
-- ATUALIZAR O A POSICAO DO VEICULO
function update()
    veiculo.x = veiculo.x + moveX
    veiculo.y = veiculo.y + moveY
end

-- função da tela repetindo
function Move_mapaScrollPai()    
 
     
    if(mapa.x - display.contentWidth < - C1W )then
         
         mapa.x = mapa.width+mapacopy.x - Velocidade
         
         Ciclos = Ciclos + 1
         
         --print(Ciclos)
         
        else
         
            mapa.x = mapa.x - Velocidade
        
        end  
     
    end
   
   
    function Move_mapaScrollFilho()  
      
      
        if(mapacopy.x - display.contentWidth < - C1W )then
            
            mapacopy.x = mapacopy.width+mapa.x
    
            else
            
                mapacopy.x = mapacopy.x - Velocidade  
    
            end
      
    end
   
end

function funcaoToque(e)
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

Runtime:addEventListener("enterFrame", update)

function cenag:show(event)

    runtime:addEventListener("enterFrame", update)
    Runtime:addEventListener("enterFrame",Move_mapaScrollPai)
    Runtime:addEventListener("enterFrame",Move_mapaScrollFilho)

end

function cenag:hide(event)

    Runtime:removeEventListener("enterFrame",update)
    Runtime:removeEventListener("enterFrame",Move_mapaScrollPai)
    Runtime:removeEventListener("enterFrame",Move_mapaScrollFilho)
  
end

function cenag:destroy(event)
 
end

cenag:addEventListener("create",cenai)
cenag:addEventListener("show",cenai)
cenag:addEventListener("hide",cenai)
cenag:addEventListener("destroy",cenai)

return cenag

--[[
function onCollision(event)
    if (event.phase == "began") then
        if (event.veiculo.myName == "veiculo")

        veiculo.isVisible = false
        --criar function
            --veiculo.bodyType = "kinematic"
        --end
        display.remove(veiculo)
    end
end
]]--