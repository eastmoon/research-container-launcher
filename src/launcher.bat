@rem
@rem Copyright 2026 the original author jacky.eastmoon
@rem

@rem ------------------- batch setting -------------------
@rem setting batch file
@rem ref : https://www.tutorialspoint.com/batch_script/batch_script_if_else_statement.htm
@rem ref : https://poychang.github.io/note-batch/

@echo off
setlocal
setlocal enabledelayedexpansion

@rem ------------------- declare variable -------------------

set IMAGE_NAME=hello-world

@rem ------------------- execute script -------------------

call :check-container
set LOOP_CALLBACK=pre-action
call :find-options %*
call :container %*
set LOOP_CALLBACK=post-action
call :find-options %*
goto end

@rem ------------------- declare function -------------------

@rem Use loop statement to find options in, if find it call processing function by LOOP_CALLBACK variable.
:find-options
  for /f "tokens=1*" %%p in ("%*") do (
      echo %%p | findstr /r "\-" >nul 2>&1
      if not errorlevel 1 (for /f "tokens=1,2 delims==" %%i in ("%%p") do (call :%LOOP_CALLBACK% %%i %%j))
      call :find-options %%q
  )
  goto end

@rem ------------------- Main method -------------------

@rem Check container image exist, if not then download it from URL.
:check-container
    docker image inspect %IMAGE_NAME% >nul 2>&1
    if errorlevel 1 (
        docker pull %IMAGE_NAME%
    )
    goto end

@rem Call container system to run with target image.
:container
    if not exist "%cd%\cache" (mkdir "%cd%\cache")
    echo %date%-%time% > "%cd%\cache\%time::=-%"
    docker run -ti --rm %IMAGE_NAME%
    goto end

@rem Processing options before calling container.
:pre-action
    set KEY=%1
    set VALUE=%2
    if "%KEY%"=="--clean" (if exist "%cd%\cache" (rd /S /Q "%cd%\cache"))
    goto end

@rem Processing options after calling container.
:post-action
    set KEY=%1
    set VALUE=%2
    if "%KEY%"=="--output" (
        if not exist "%VALUE%" (mkdir "%VALUE%")
        if exist "%cd%\cache" (xcopy /Q /Y "%cd%\cache" "%VALUE%")
    )
    goto end

@rem ------------------- End method-------------------

:end
    endlocal
