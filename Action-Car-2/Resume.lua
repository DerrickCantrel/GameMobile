composer = require( "composer" )
cenar = composer.newScene()

scoreShow = 0 

function cenar:create(event)

    local grupoR = self.view

    backFade = display.newImageRect("imgs/gamerover1.png",800,480)
    backFade.x = display.contentWidth/2
    backFade.y = display.contentHeight/2

    grupoR:insert(backFade)

    tenteNovamente = display.newImageRect("imgs/gamer over 2.png",200,50)
    tenteNovamente.x = display.contentWidth/2
    tenteNovamente.y = display.contentHeight/2
    tenteNovamente.myName = "Novamente"

    grupoR:insert(tenteNovamente)

    Titulo = display.newText("SCORE",display.contentWidth/2,display.contentHeight/10,native.systemFontBold,30)
	Titulo:setFillColor(0,0,0)
	
    grupoR:insert(Titulo)
    
    --Texto = display.newText(scoreShow,display.contentWidth/3.8,display.contentHeight/3,"Arial",40)    
	--Texto:setFillColor(0,0,0)
    --grupoR:insert(Texto)
  
end

function tentarNovamente(event)
    if event.phase == "began" then
        if event.target.myName == "Novamente" then
            composer.gotoScene("Game", 800)
        end
    end
end

function cenar:show(event)

composer.removeScene( "Game", true )
Runtime:addEventListener("touch",tentarNovamente)
    
end
    
function cenar:hide(event)
    
Runtime:removeEventListener("touch",tentarNovamente)
        
end
    
function cenar:destroy(event)
    
end
    
cenar:addEventListener("create",cenar)
cenar:addEventListener("show",cenar)
cenar:addEventListener("hide",cenar)
cenar:addEventListener("destroy",cenar)
    
return cenar