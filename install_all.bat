@echo off
setlocal enabledelayedexpansion

:: 📌 Set folder paths for Visual C++ Runtimes
set VC_FOLDER=%TEMP%\Visual-C-Runtimes-All-in-One-Nov-2024
set VC_INSTALL_FOLDER=%VC_FOLDER%\install
set VC_ZIP_FILE="%VC_FOLDER%\Visual-C-Runtimes.zip"
set VC_URL=https://sg1-dl.techpowerup.com/files/1Nd7JlhDVXo-u6KUBh7jWg/1739840772/Visual-C-Runtimes-All-in-One-Nov-2024.zip

:: 📌 Set folder paths for DirectX
set DX_FOLDER=%TEMP%\NewFolder
set DX_SETUP="%DX_FOLDER%\DXSETUP.exe"
set DX_URL=https://download.microsoft.com/download/8/4/a/84a35bf1-dafe-4ae8-82af-ad2ae20b6b14/directx_Jun2010_redist.exe
set DX_EXE="%DX_FOLDER%\directx_Jun2010_redist.exe"

:: 🔹 Create folders for Visual C++ Runtimes
if not exist "%VC_FOLDER%" mkdir "%VC_FOLDER%"
if not exist "%VC_INSTALL_FOLDER%" mkdir "%VC_INSTALL_FOLDER%"

:: 🔽 Download Visual C++ Runtimes
echo 🔽 Downloading Visual C++ Runtimes...
curl -L "%VC_URL%" -o %VC_ZIP_FILE%

:: 🔹 Check if download was successful
if not exist %VC_ZIP_FILE% (
    echo ❌ Failed to download Visual C++! Check internet connection.
    exit /b
)

echo ✅ Visual C++ download completed!

:: 🔹 Extract files to `install` folder
echo 📂 Extracting Visual C++ to %VC_INSTALL_FOLDER%...
powershell -command "Expand-Archive -Path %VC_ZIP_FILE% -DestinationPath %VC_INSTALL_FOLDER% -Force"

:: 🔹 Check if extraction was successful
if %errorlevel% neq 0 (
    echo ❌ Failed to extract Visual C++ files! Check ZIP file or system permissions.
    exit /b
)

echo ✅ Visual C++ files extracted successfully to: %VC_INSTALL_FOLDER%

:: 🔹 Delete ZIP file after extraction
del %VC_ZIP_FILE%

:: 🔹 Find and execute `.bat` files in `install` folder
echo 🔹 Running .bat files for Visual C++ installation...
for %%F in ("%VC_INSTALL_FOLDER%\*.bat") do (
    echo 🔹 Running script: %%F...
    start /wait "Running Script" "%%F"
)

echo ✅ Visual C++ installation completed!

:: 🔹 Create folder for DirectX installation
if not exist "%DX_FOLDER%" mkdir "%DX_FOLDER%"

:: 🔽 Download DirectX from Microsoft
echo 🔽 Downloading DirectX...
curl -L "%DX_URL%" -o %DX_EXE%

:: 🔹 Check if download was successful
if not exist %DX_EXE% (
    echo ❌ Failed to download DirectX! Check internet connection.
    exit /b
)

echo ✅ DirectX download completed!

:: 🔹 Extract DirectX SDK files to `%TEMP%\NewFolder`
echo 📂 Extracting DirectX SDK...
"%DX_EXE%" /Q /T:"%DX_FOLDER%"

:: 🔹 Run DXSETUP for automatic DirectX installation
if exist %DX_SETUP% (
    echo ⚙ Installing DirectX...
    "%DX_SETUP%" /silent
    echo ✅ DirectX installation completed!
) else (
    echo ❌ DXSETUP.exe not found! DirectX installation failed.
)

:: 🔥 Delete all temporary files and folders after completion
echo 🔥 Cleaning up temporary files...
rmdir /s /q "%VC_FOLDER%"
rmdir /s /q "%DX_FOLDER%"

echo 🎉 Installation of Visual C++ and DirectX completed successfully!
exit
