@echo off
title CodeQuest - Server Launcher
echo ========================================================
echo   Starting CodeQuest Learning Platform (Tomcat 10.1)
echo ========================================================

set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.20.8-hotspot"
set "JRE_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.20.8-hotspot"
set "CATALINA_HOME=%~dp0tomcat\apache-tomcat-10.1.20"
set "CATALINA_BASE=%~dp0tomcat\apache-tomcat-10.1.20"

echo [1/2] Syncing webapp files to Tomcat...
xcopy /E /I /Y "%~dp0src\main\webapp" "%CATALINA_BASE%\webapps\codequest" >nul
xcopy /E /I /Y "%~dp0src\main\webapp" "%CATALINA_BASE%\webapps\ROOT" >nul

echo [2/2] Launching Apache Tomcat 10.1...
echo CodeQuest is available at: http://localhost:8080/codequest/
start http://localhost:8080/codequest/
call "%CATALINA_HOME%\bin\catalina.bat" run
