local composer = require( "composer" )
local cenar = composer.newScene()

function cenar:create(event)

    local grupoR = self.view

    background = display.newImage("imgs/fim.jpg")
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2
    background:scale(0.7, 0.7)

    grupoR:insert(background)

    tenteNovamente = display.newImage("imgs/tentarNovamente.png")
    tenteNovamente.x = display.contentWidth/2; tenteNovamente.y = display.contentHeight/2
    tenteNovamente:scale(0.6, 0.6)

    grupoR:insert(tenteNovamente)

    soundGO = audio.loadStream("sounds/Action Fighter -02- Game Over.wav")
    audio.setVolume(.1)
end

function restart(event)
    if event.phase == "began" then
        composer.gotoScene("Game", "fade", 400)
    end
end

function cenar:show(event)

    composer.removeHidden()
    tenteNovamente:addEventListener("touch", restart)
    audio.play( soundGO, { channel=1, loops=-1 } )
    
end
    
function cenar:hide(event)
    
    tenteNovamente:removeEventListener("touch", restart)
    audio.stop()
        
end
    
function cenar:destroy(event)
    
end
    
cenar:addEventListener("create",cenar)
cenar:addEventListener("show",cenar)
cenar:addEventListener("hide",cenar)
cenar:addEventListener("destroy",cenar)
    
return cenar