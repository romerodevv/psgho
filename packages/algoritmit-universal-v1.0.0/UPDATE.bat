@echo off
echo 🔄 Updating ALGORITMIT...
echo.

echo 📥 Downloading latest version...
curl -L https://github.com/romerodevv/psgho/archive/main.zip -o update.zip

echo 📂 Extracting files...
powershell -command "Expand-Archive -Force update.zip ."
xcopy /E /Y psgho-main\* .
rmdir /S /Q psgho-main
del update.zip

echo 📦 Updating dependencies...
npm install

echo ✅ Update complete!
pause
