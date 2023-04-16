function onCreatePost()
	--debugPrint(getProperty('gf.curCharacter'));
	--if (gfName == 'mattBgNutshell') then
	if (getProperty('gf.curCharacter') == 'mattBgNutshell' or getProperty('gf.curCharacter') == 'chaseBoombox' or getProperty('gf.curCharacter') == 'adielBoombox' or getProperty('gf.curCharacter') == 'chaseBoomboxFlipnoteRed' or getProperty('gf.curCharacter') == 'chaseBoomboxFlipnoteBlue') then
		--debugPrint('matt');
		setScrollFactor('gfGroup', 1, 1);
	end
end

--[[function onEvent(name, value1, value2)
	if (name == 'Change Character') then
		if (getProperty('gf.curCharacter') == 'mattBgNutshell' or getProperty('gf.curCharacter') == 'chaseBoombox' or getProperty('gf.curCharacter') == 'adielBoombox' or getProperty('gf.curCharacter') == 'chaseBoomboxFlipnoteRed' or getProperty('gf.curCharacter') == 'chaseBoomboxFlipnoteBlue') then
			setScrollFactor('gfGroup', 1, 1);
		else
			setScrollFactor('gfGroup', 0.95, 0.95);
		end
	end
	--print('Event triggered: ', name, value1, value2);
end]]--