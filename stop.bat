@echo off
title CodeQuest - Server Shutdown
echo ========================================================
echo   Stopping CodeQuest Tomcat Server
echo ========================================================

set "JAVA_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.20.8-hotspot"
set "JRE_HOME=C:\Program Files\Eclipse Adoptium\jdk-17.0.20.8-hotspot"
set "CATALINA_HOME=%~dp0tomcat\apache-tomcat-10.1.20"
set "CATALINA_BASE=%~dp0tomcat\apache-tomcat-10.1.20"

call "%CATALINA_HOME%\bin\catalina.bat" stop
echo Server stopped successfully.
