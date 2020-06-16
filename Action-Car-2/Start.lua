composer = require "composer"
cenai = composer.newScene()


function cenai:create(event)

    local grupoI = self.view
    
    background = display.newImage("imgs/inicio.jpg")
    background.x = display.contentWidth/2
    background.y = display.contentHeight/2
    background:scale(0.7, 0.7)
	
    grupoI:insert(background)
    
    sheetOptions =
    {
        width = 400,
        height = 200,
        numFrames = 2
    }

    titulo_sheet = graphics.newImageSheet("imgs/titulo_spri.png", sheetOptions)

    sequences_titulos = {
        -- consecutive frames sequence
        {
            name = "normalRun",
            start = 1,
            count = 2,
            time = 800,
            loopCount = 0,
            loopDirection = "forward"
        }
    }

    titulo_Spri = display.newSprite( titulo_sheet, sequences_titulos )
    titulo_Spri.x = 120
    titulo_Spri.y = 80
    titulo_Spri:scale(0.8, 0.8)
    titulo_Spri:play()

    grupoI:insert(titulo_Spri)

    buttomStart = display.newImage("imgs/inicio.png")
    buttomStart.x = display.contentWidth/2; buttomStart.y = display.contentHeight/2
    buttomStart:scale(0.6, 0.6)

    grupoI:insert(buttomStart)

    musicBack = audio.loadStream("sounds/Timecop1983 - On the Run.wav")
    audio.setVolume(.2)
end

function start(event)

    if(event.phase=="began") then
        composer.gotoScene("Game", "fade", 400)
    end
end

function cenai:show(event)

    buttomStart:addEventListener("touch", start)
    audio.play( musicBack, { channel=1, loops=-1 } )
        
end
    
function cenai:hide(event)
    
    buttomStart:removeEventListener("touch", start)
    audio.stop()

end
    
function cenai:destroy(event)
    --local sceneGroup = self.view
    --audio.dispose( musicBack )
end
    
cenai:addEventListener("create",cenai)
cenai:addEventListener("show",cenai)
cenai:addEventListener("hide",cenai)
cenai:addEventListener("destroy",cenai)
    
return cenai