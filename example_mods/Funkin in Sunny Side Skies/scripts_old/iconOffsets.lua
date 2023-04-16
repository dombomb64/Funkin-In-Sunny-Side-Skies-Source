-- NOTE:
-- Feel free to use this script in your mods!
-- Just make sure to give credit to me, dombomb64.
-- (You can delete all the commented-out code, most of it is remnants from past attempts.)
-- Related Scripts: pixelIcons, winningIcons (You can use those, too.)

--function onCreatePost()
--	iconP1DefaultX = getProperty('iconP1.x');
--	iconP2DefaultX = getProperty('iconP2.x');
	--runTimer('iconOffsets', 0.1, 1);
--end

--function onBeatHit()
--	setProperty("iconP2.x", 100);
--end

--function onUpdate()
	--debugPrint(getProperty('iconP1.offset.x'));
--end

function onUpdatePost(elapsed)
	--if tag == 'iconOffsets' then
	--debugPrint('icon timer');
	--Reset offsets to 0
	iconP1X = 0;
	iconP1Y = 0;
	iconP2X = 0;
	iconP2Y = 0;

	--debugPrint(boyfriendName);

	local bf = getProperty('iconP1.char');
	local dad = getProperty('iconP2.char');

	--        Icon name                                Offset x, y
	if (bf == 'chaseImpostor') then iconP1X, iconP1Y = -10, -8;
	elseif (bf == 'chaseInfected') then iconP1X, iconP1Y = -10, -8;
	elseif (bf == 'adamCrewmate') then iconP1X, iconP1Y = -10, 8;
	elseif (bf == 'adamInfected') then iconP1X, iconP1Y = -10, 8;
	elseif (bf == 'chaseNutshell') then iconP2X, iconP2Y = 0, -8;
	elseif (bf == 'chaseWorried') then iconP2X, iconP2Y = 0, -8;
	elseif (bf == 'chaseFlipnoteRed') then iconP2X, iconP2Y = 0, -8;
	elseif (bf == 'chaseFlipnoteBlue') then iconP2X, iconP2Y = 0, -8;
	elseif (bf == 'jimNutshell') then iconP2X, iconP2Y = 0, -20;
	end

	--Copy and paste bf offset code here (or vice versa) and flip the sign of the X value
	if (dad == 'chaseImpostor') then iconP2X, iconP2Y = 10, -8;
	elseif (dad == 'chaseInfected') then iconP1X, iconP1Y = 10, -8;
	elseif (dad == 'adamCrewmate') then iconP2X, iconP2Y = 10, 8;
	elseif (dad == 'adamInfected') then iconP1X, iconP1Y = 10, 8;
	elseif (dad == 'chaseNutshell') then iconP2X, iconP2Y = 0, -8;
	elseif (dad == 'chaseWorried') then iconP2X, iconP2Y = 0, -8;
	elseif (dad == 'chaseFlipnoteRed') then iconP2X, iconP2Y = 0, -8;
	elseif (dad == 'chaseFlipnoteBlue') then iconP2X, iconP2Y = 0, -8;
	elseif (dad == 'jimNutshell') then iconP2X, iconP2Y = 0, -20;
	end
	--debugPrint('test');

	--Set offsets
	setProperty('iconP1.offset.x', iconP1X);
	setProperty('iconP1.offset.y', iconP1Y);
	setProperty('iconP2.offset.x', iconP2X);
	setProperty('iconP2.offset.y', iconP2Y);

	setProperty('bfIcon.offset.x', iconP1X);
	setProperty('bfIcon.offset.y', iconP1Y);
	setProperty('dadIcon.offset.x', iconP2X);
	setProperty('dadIcon.offset.y', iconP2Y);

	--setPropertyFromGroup('iconP1.iconOffsets', 0, 0, iconP1X);
	--debugPrint(getPropertyFromGroup('iconP1.iconOffsets', 0, 0));
	--[[setProperty('iconP1.offset.y', iconP1Y);
	setProperty('iconP2.offset.x', iconP2X);
	setProperty('iconP2.offset.y', iconP2Y);

	setProperty('bfIcon.offset.x', iconP1X);
	setProperty('bfIcon.offset.y', iconP1Y);
	setProperty('dadIcon.offset.x', iconP2X);
	setProperty('dadIcon.offset.y', iconP2Y);]]--

	--setProperty('iconP2.x', iconP2DefaultX + iconP2X);
	--iconP2DefaultX = getProperty('iconP2.x') - iconP2X;
	--setProperty('iconP2.x', 100);
	--doTweenX('iconP2TweenX', 'iconP2', 100, 0, 'linear');

	--doTweenX('iconP2TweenX', 'iconP2', iconP2DefaultX + iconP2X, 0, 'linear');
	--doTweenY('iconP2TweenY', 'iconP2', getProperty('healthBar.y') - 75 + iconP2Y, 0, 'linear');
	--end
end