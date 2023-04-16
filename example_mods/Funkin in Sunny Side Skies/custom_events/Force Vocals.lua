local forceVocals = false;

function onEvent(name, value1, value2)
	if name == 'Force Vocals' then
		forceVocals = true
	end
end

function onBeatHit()
	if forceVocals == true then
		setProperty('vocals.volume', 1);
		forceVocals = false;
	end
end