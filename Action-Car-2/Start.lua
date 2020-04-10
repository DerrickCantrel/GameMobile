


composer = require "composer"
cenai = composer.newScene()




function cenai:create(event)

    local grupoI = self.view
    
    Imagem = display.newImageRect("imgs/inicio.jpg",display.contentWidth*1.19,display.contentHeight)
    Imagem.x = display.contentWidth/2
	Imagem.y = display.contentHeight/2
	
	grupoI:insert(Imagem)

    texto = display.newText("Toque para Iniciar",display.contentWidth/2,display.contentHeight/1.09)
	texto:setFillColor(0,0,0)
	
    grupoI:insert(texto)
    
    contagem = 0
    
end

function Tempo()

	if(contagem >= 50)then
		
		transition.fadeOut(Imagem,{time = 800})
		contagem = 100
		else
		contagem = contagem + .5
	end
	
	print(contagem)

end

display.setDefault( "background", 1, 1, 1 )

function GameI()

    customData = { var1 = anim, myVar= p }
    cenai = composer.loadScene( "Game", false, customData )
    composer.gotoScene("Game","fade",95) 

end

function Touch(event)

    if(event.phase=="began") then
        
        timer.performWithDelay(1000,GameI,1)    
        Runtime:removeEventListener("touch",Touch)
    end

    
end


function cenai:show(event)

Runtime:addEventListener("enterFrame",Tempo)
Runtime:addEventListener("touch",Touch)
    
    
end
    
function cenai:hide(event)
    
Runtime:removeEventListener("enterFrame",Tempo)
Runtime:removeEventListener("touch",Touch)
    
end
    
function cenai:destroy(event)
    
end
    
cenai:addEventListener("create",cenai)
cenai:addEventListener("show",cenai)
cenai:addEventListener("hide",cenai)
cenai:addEventListener("destroy",cenai)
    
return cenai