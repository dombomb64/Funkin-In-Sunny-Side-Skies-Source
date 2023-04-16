function onCreate()
	--debugPrint(difficulty);
	if difficulty == 3 then
		--setProperty("instakillOnMiss", true);
		setProperty("healthBar.alpha", 0.0);
		setProperty("healthGain", 0);
		setProperty("healthLoss", 100);
	end
end