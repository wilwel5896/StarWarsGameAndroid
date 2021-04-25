--Created by Will Wellington 3/3/2014

display.setStatusBar(display.HiddenStatusBar)

local centerX = display.contentCenterX
local centerY = display.contentCenterY

--set up forward references

local spawnEnemy
local gameTitle
local scoreTxt
local score = 1 
local hitdeathstar
local deathstar
local shipDestroyed
--local speedBump = 0


--preload audio

local sndKill = audio.loadSound("boing-1.wav")
local sndBlast = audio.loadSound("explosion.wav")
local sndLose = audio.loadSound("bigexplosion.wav")


--play screen
local function createPlayScreen()

local background2 = display.newImage("background2.png")
background2.y = 200
background2.alpha = 0

deathstar = display.newImage("deathstar.png")
deathstar.x = centerX
deathstar.y = display.contentHeight + 60
deathstar.alpha = .5
deathstar.xScale = 2
deathstar.yScale = 2


transition.to(background2, {time=2000, alpha=1, y=centerY, x=centerX})

local function showTitle()
	gameTitle = display.newImage("title.png")
	gameTitle.alpha=0
	gameTitle:scale(4, 4)
	transition.to( gameTitle, {time=100, alpha=1, xScale=1, yScale=1})
	startGame()
end
transition.to(deathstar, {time = 2000, alpha=1, xScale=.4, yScale=.4, y=centerY, onComplete=showTitle  })

scoreTxt=display.newText( "Score: 1", 0, 0, "Helvetica", 22)
		scoreTxt.x=centerX
		scoreTxt.y=10
		score=1
		scoreTxt.alpha = 0

end
--game functions

function spawnEnemy()

	local enemypics = {"rock1.png","rock2.png", "xwing.png"}
	local enemy = display.newImage(enemypics[math.random (#enemypics)])
    enemy:addEventListener ("tap", shipSmash)

    if math.random(2) == 1 then
    	enemy.x = math.random (-100, -10)
    	enemy.xScale = -1
    else 
    	enemy.x = math.random (display.contentWidth + 10, display.contentWidth + 100)

    end
    enemy.y = math.random (display.contentHeight)
	enemy.trans = transition.to ( enemy, { x=centerX, y=centerY, time=30000/score, onComplete=hitdeathstar } )
	--speedBump = speedBump + 50



end

function startGame()
	local directions = display.newImage("directions.png")
	directions.x = centerX
	directions.y = display.contentHeight - 30
	local function goAway(event)
		display.remove(event.target)
		event.target = nil
		directions = nil
		spawnEnemy()
		display.remove(gameTitle)
		scoreTxt.alpha = 1
		scoreTxt.text = "Score: 1"
		score = 1
		deathstar.numHits = 20
		deathstar.alpha = 1 
		speedBump = 0 --start ship spee
		end
	directions:addEventListener("tap", goAway) --tap go away duh
end

local function deathstarDamage()
	deathstar.numHits = deathstar.numHits -2 --every hit is -2
	deathstar.alpha = deathstar.numHits / 20 --alpha turns to numberofhits/20
	if deathstar.numHits < 2 then
		deathstar.alpha = 0
		timer.performWithDelay (4000, startGame) --delay after losing on when game should start
		audio.play(sndLose) --plays audio after losing
	else
local function goAway(obj)
		deathstar.xScale = .4 --size after getting hit
		deathstar.yScale = .4 --size after getting hit
		deathstar.alpha = deathstar.numHits / 3 --fade after hit
	end
	--per hit
	transition.to ( deathstar, {time=200, xScale=.6, yScale=.6, alpha=2, onComplete=goAway})
end
end

function hitdeathstar(obj)
	display.remove(obj)
	deathstarDamage()
	audio.play(sndBlast)
		if deathstar.numHits > 1 then
		spawnEnemy()
	end
end

function shipSmash(event)
	local obj = event.target
	display.remove(obj)
	enemy = nil
	audio.play(sndKill)
	transition.cancel (event.target.trans)
	score = score + 1
	scoreTxt.text = "Score: " .. score
	spawnEnemy()

return true
end

	createPlayScreen()


