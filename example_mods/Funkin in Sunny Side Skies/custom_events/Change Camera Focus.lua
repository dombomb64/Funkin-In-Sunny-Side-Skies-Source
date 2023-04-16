--[[function onCreatePost()
	local originalZoom = getProperty('defaultCamZoom');
end]]--

local cameraFocus = 'boyfriend';
local eventBeat = 0;

function onEvent(name, value1, value2)
	if name == 'Change Camera Focus' then
		--debugPrint('n', value1, 'n');
		--if value2 ~= '' then
			--originalZoom = value2;
		--end

		cameraFocus = value1;
		runTimer('eventBeat', 0.01, 1);

		--if value1 ~= '' then
			--debugPrint(value1);
			runTimer('changeCameraFocus', 0.02, 100);
		--end
	end
	--debugPrint(value1, ' ', getProperty('defaultCamZoom'));
	--debugPrint('Event triggered: ', name, value1, value2);
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'changeCameraFocus' then
		--debugPrint(curBeat, '', eventBeat);
		--if curBeat > eventBeat then
			--cancelTimer('changeCameraFocus');
		--else
			if cameraFocus == 'boyfriend' or cameraFocus == 'bf' then
				cameraSetTarget('boyfriend');
				triggerEvent('Camera Follow Pos', getProperty('camFollow.x'), getProperty('camFollow.y'));
			elseif cameraFocus == 'girlfriend' or cameraFocus == 'gf' then
				cameraSetTarget('gf');
				triggerEvent('Camera Follow Pos', getProperty('camFollow.x'), getProperty('camFollow.y'));
			elseif cameraFocus == 'dad' or cameraFocus == 'opponent' then
				cameraSetTarget('dad');
				triggerEvent('Camera Follow Pos', getProperty('camFollow.x'), getProperty('camFollow.y'));
			elseif cameraFocus == 'boyfriend2' or cameraFocus == 'bf2' then
				cameraSetTarget('boyfriend2');
				triggerEvent('Camera Follow Pos', getProperty('camFollow.x'), getProperty('camFollow.y'));
			elseif cameraFocus == 'dad2' or cameraFocus == 'opponent2' then
				cameraSetTarget('dad2');
				triggerEvent('Camera Follow Pos', getProperty('camFollow.x'), getProperty('camFollow.y'));
			else
				triggerEvent('Camera Follow Pos', '', '');
			end
		--end
	elseif tag == 'eventBeat' then
		eventBeat = curBeat;
	end
end