function start()
	--defaultScrollSpeed = scrollSpeed
end

function update (elapsed)
	local currentBeat = (songPos / 1000) * (bpm / 60)
	--if math.floor(currentBeat) % 2 == 0 then
		--scrollSpeed = math.cos(songPos * 100) * defaultScrollSpeed
		strumLineY = _G['receptor_'..0] + 10 * math.cos((currentBeat + i * 0.25) * math.pi)
		for i = 0, 7, 1 do
			local receptor = _G['receptor_'..i]
			--receptor.y = receptor.defaultY + 10 * math.cos((currentBeat + i * 0.25) * math.pi)
		end
		--for i = 0, 7 do
			--setActorY(defaultStrum0Y + 10 * math.cos((currentBeat + i * 0.25) * math.pi), i)
		--end
		--for i = 0, getNumberOfNotes() do
			--local note = _G['note_'..i]
			--note.x = 50 * math.cos(note.y * 360)
			--note.tweenPos(1,note.x + 100 * math.cos((currentBeat + i * 0.25) * math.pi),note.y + 100 * math.cos((currentBeat + i * 0.25) * math.pi))
		--end
	--end
end

function playerTwoTurn()
    --camGame:tweenZoom(1.3,(crochet * 4) / 1000)
end

function playerOneTurn()
    --camGame:tweenZoom(1,(crochet * 4) / 1000)
end