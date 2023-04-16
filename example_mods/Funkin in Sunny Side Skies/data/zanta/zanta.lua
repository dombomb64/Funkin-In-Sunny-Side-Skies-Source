function onCreate()
	addCharacterToList('chaseZanta');
end

function onBeatHit()
	if curBeat == 404 then
		setProperty('boyfriend.flipX', true);
	elseif curBeat == 424 then
		cameraFlash('game', '000000', 99999999, true);
		--setProperty('boyfriend.flipX', false);
		addLuaSprite('chaseApartmentBg3', false);
		removeLuaSprite('chaseApartmentBg2', false);
		setProperty('boyfriend.x', 420);
		setProperty('dad.x', -1200);
	elseif curBeat == 432 then
		cameraFlash('game', 'ffffff', crochet / 1000, true);
		--setProperty('defaultCamZoom', getProperty('defaultCamZoom') / 2);
		--setProperty('camGame.zoom', getProperty('camGame.zoom') / 2);
	elseif curBeat == 492 then
		doTweenZoom('zoomIn', 'camGame', 1.5, crochet / 1000 * 4, 'sineIn');
	elseif curBeat == 496 then
		cameraFlash('game', '000000', 99999999, true);
		setProperty('boyfriend.x', defaultBoyfriendX);
		setProperty('dad.x', defaultOpponentX);
		--setProperty('camGame.x', 0);
		--setProperty('camGame.y', 0);
		triggerEvent('Camera Follow Pos', '', '');
	elseif curBeat == 498 then
		cameraFlash('game', 'ffffff', 0.01, true);
		addLuaSprite('chaseApartmentBg2', false);
		addLuaSprite('chaseApartmentBg4', false);
		removeLuaSprite('chaseApartmentBg3', false);
	elseif curBeat == 604 then
		doTweenZoom('zoomIn', 'camGame', 1.25, crochet / 1000 * 32, 'sineInOut');
	end
end

function opponentNoteHit(id, direction, noteType, isSustainNote)
	if curBeat >= 432 and curBeat <= 496 then
		--local chaseCamX = 1110; --getProperty('boyfriend.x') + 440;
		--local chaseCamY = 210; --getProperty('boyfriend.y') - 540;
		
		local chaseCamX = (getProperty('boyfriend.x') + getProperty('boyfriend.width') / 2) - 100;
		local chaseCamY = (getProperty('boyfriend.y') + getProperty('boyfriend.height') / 2) - 100;
		chaseCamX = chaseCamX - getProperty('boyfriend.cameraPosition[0]') - getProperty('opponentCameraOffset[0]');
		chaseCamY = chaseCamY + getProperty('boyfriend.cameraPosition[1]') + getProperty('opponentCameraOffset[1]');

		local cameraMove = 120;
		local leftPos = chaseCamX - cameraMove;
		local downPos = chaseCamY + cameraMove;
		local upPos = chaseCamY - cameraMove;
		local rightPos = chaseCamX + cameraMove;

		if direction == 0 then
			--doTweenX('dadSingLeft', 'camGame.scroll', -100, 0.2, 'sineInOut');
			--triggerEvent("Camera Follow Pos", tostring(getPropertyFromGroup('boyfriend.cameraPosition', 0, 0)), tostring(getPropertyFromGroup('boyfriend.cameraPosition', 1, 0)));
			triggerEvent('Camera Follow Pos', leftPos, chaseCamY);
			--setProperty('boyfriend.x', getProperty('boyfriend.x') - cameraMove);
			--setProperty('boyfriend.offset.x', getProperty('boyfriend.offset.x') + cameraMove); 
		elseif direction == 1 then
			--doTweenY('dadSingDown', 'camGame.scroll', 100, 0.2, 'sineInOut');
			triggerEvent('Camera Follow Pos', chaseCamX, downPos);
		elseif direction == 2 then
			--doTweenY('dadSingUp', 'camGame.scroll', -100, 0.2, 'sineInOut');
			triggerEvent('Camera Follow Pos', chaseCamX, upPos);
		elseif direction == 3 then
			--doTweenX('dadSingRight', 'camGame.scroll', 100, 0.2, 'sineInOut');
			triggerEvent('Camera Follow Pos', rightPos, chaseCamY);
		end
	end
end