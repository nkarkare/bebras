set /a count=0
setlocal ENABLEDELAYEDEXPANSION
for /F "tokens=*" %%i in (tasks.txt) do (
	set /a count=count+1


	echo ***Processing for %%i***
	echo Copying EN...
	copy C:\tmp\Bebras2024\EN\%%i_EN.docx C:\tmp\Bebras2024\Processed\EN\!count!_%%i_EN.docx
	if exist C:\tmp\Bebras2024\Processed\EN\!count!_%%i_EN.docx (
		set /a count=count+1
		Rem SOLN are ALL in ENGLISH only
		Rem but check if the question file exists before copying the solution file
		echo Copying solutions to EN...
		copy C:\tmp\Bebras2024\EN\%%i_EN_SOLN.docx C:\tmp\Bebras2024\Processed\EN\!count!_%%i_EN_SOLN.docx
	)

	echo Copying BN...
	copy C:\tmp\Bebras2024\BN\%%i_BN.docx C:\tmp\Bebras2024\Processed\BN\!count!_%%i_BN.docx
	if exist C:\tmp\Bebras2024\Processed\BN\!count!_%%i_BN.docx (
		set /a count=count+1
		Rem SOLN are ALL in ENGLISH only
		Rem but check if the question file exists before copying the solution file
		Rem echo Copying solutions to BN...
		Rem copy C:\tmp\Bebras2024\BN\%%i_EN_SOLN.docx C:\tmp\Bebras2024\Processed\BN\!count!_%%i_EN_SOLN.docx
	)

	echo Copying PA...
	copy C:\tmp\Bebras2024\PA\%%i_PA.docx C:\tmp\Bebras2024\Processed\PA\!count!_%%i_PA.docx
	if exist C:\tmp\Bebras2024\Processed\PA\!count!_%%i_PA.docx (
		set /a count=count+1
		Rem SOLN are ALL in ENGLISH only
		Rem but check if the question file exists before copying the solution file
		Rem echo Copying solutions to PA...
		Rem copy C:\tmp\Bebras2024\PA\%%i_EN_SOLN.docx C:\tmp\Bebras2024\Processed\PA\!count!_%%i_EN_SOLN.docx
	)

	echo Copying HI...
	copy C:\tmp\Bebras2024\HI\%%i_HI.docx C:\tmp\Bebras2024\Processed\HI\!count!_%%i_HI.docx
	if exist C:\tmp\Bebras2024\Processed\HI\!count!_%%i_HI.docx (
		set /a count=count+1
		Rem SOLN are ALL in ENGLISH only
		Rem but check if the question file exists before copying the solution file
		Rem echo Copying solutions to HI...
		Rem copy C:\tmp\Bebras2024\HI\%%i_EN_SOLN.docx C:\tmp\Bebras2024\Processed\HI\!count!_%%i_EN_SOLN.docx
	)
	
	echo Copying MR...
	copy C:\tmp\Bebras2024\MR\%%i_MR.docx C:\tmp\Bebras2024\Processed\MR\!count!_%%i_MR.docx
	if exist C:\tmp\Bebras2024\Processed\MR\!count!_%%i_MR.docx (
		set /a count=count+1
		Rem SOLN are ALL in ENGLISH only
		Rem but check if the question file exists before copying the solution file
		Rem echo Copying solutions to MR...
		Rem copy C:\tmp\Bebras2024\EN\%%i_EN_SOLN.docx C:\tmp\Bebras2024\Processed\MR\!count!_%%i_EN_SOLN.docx
	)


	echo Copying GU...
	copy C:\tmp\Bebras2024\GU\%%i_GU.docx C:\tmp\Bebras2024\Processed\GU\!count!_%%i_GU.docx
	if exist C:\tmp\Bebras2024\Processed\GU\!count!_%%i_GU.docx (
		set /a count=count+1
		Rem SOLN are ALL in ENGLISH only
		Rem but check if the question file exists before copying the solution file
		Rem echo Copying solutions to GU...
		Rem copy C:\tmp\Bebras2024\EN\%%i_EN_SOLN.docx C:\tmp\Bebras2024\Processed\GU\!count!_%%i_EN_SOLN.docx
	)


	echo Copying KA...
	copy C:\tmp\Bebras2024\KA\%%i_KA.docx C:\tmp\Bebras2024\Processed\KA\!count!_%%i_KA.docx
	if exist C:\tmp\Bebras2024\Processed\KA\!count!_%%i_KA.docx (
		set /a count=count+1
		Rem SOLN are ALL in ENGLISH only
		Rem but check if the question file exists before copying the solution file
		Rem echo Copying solutions to KA...
		Rem copy C:\tmp\Bebras2024\EN\%%i_EN_SOLN.docx C:\tmp\Bebras2024\Processed\KA\!count!_%%i_EN_SOLN.docx
	)


	echo Copying OR...
	copy C:\tmp\Bebras2024\OR\%%i_OR.docx C:\tmp\Bebras2024\Processed\OR\!count!_%%i_OR.docx
	if exist C:\tmp\Bebras2024\Processed\OR\!count!_%%i_OR.docx (
		set /a count=count+1
		Rem SOLN are ALL in ENGLISH only
		Rem but check if the question file exists before copying the solution file
		Rem echo Copying solutions to OR...
		Rem copy C:\tmp\Bebras2024\EN\%%i_EN_SOLN.docx C:\tmp\Bebras2024\Processed\OR\!count!_%%i_EN_SOLN.docx
	)


	echo Copying TA...
	copy C:\tmp\Bebras2024\TA\%%i_TA.docx C:\tmp\Bebras2024\Processed\TA\!count!_%%i_TA.docx
	if exist C:\tmp\Bebras2024\Processed\TA\!count!_%%i_TA.docx (
		set /a count=count+1
		Rem SOLN are ALL in ENGLISH only
		Rem but check if the question file exists before copying the solution file
		Rem echo Copying solutions to TA...
		Rem copy C:\tmp\Bebras2024\EN\%%i_EN_SOLN.docx C:\tmp\Bebras2024\Processed\TA\!count!_%%i_EN_SOLN.docx
	)


	echo Copying TE...
	copy C:\tmp\Bebras2024\TE\%%i_TE.docx C:\tmp\Bebras2024\Processed\TE\!count!_%%i_TE.docx
	if exist C:\tmp\Bebras2024\Processed\TE\!count!_%%i_TE.docx (
		set /a count=count+1
		Rem SOLN are ALL in ENGLISH only
		Rem but check if the question file exists before copying the solution file
		Rem echo Copying solutions to TE...
		Rem copy C:\tmp\Bebras2024\EN\%%i_EN_SOLN.docx C:\tmp\Bebras2024\Processed\TE\!count!_%%i_EN_SOLN.docx
	)
	echo ***DONE Processing for %%i***
	echo
	echo
)
endlocal
