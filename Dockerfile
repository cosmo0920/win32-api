FROM mcr.microsoft.com/windows/servercore:20H2
LABEL maintainer "Hiroshi Hatake <cosmo0920.wp@gmail.com>"
LABEL Description="win32-api building docker image"

# Do not split this into multiple RUN!
# Docker creates a layer for every RUN-Statement
RUN powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

# Ruby 3.0 and 3.1
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-3.0.0-1-x64.exe https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.0-1/rubyinstaller-3.0.0-1-x64.exe
RUN cmd /c "C:\rubyinstaller-3.0.0-1-x64.exe" /silent /dir=c:\ruby30-x64
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-3.1.6-1-x64.exe https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.1.6-1/rubyinstaller-3.1.6-1-x64.exe
RUN cmd /c "C:\rubyinstaller-3.1.6-1-x64.exe" /silent /dir=c:\ruby31-x64

# DevKit
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe https://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe
RUN cmd /c C:\DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe -o"c:\DevKit64" -y
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile rubyinstaller-devkit-3.1.6-1-x64.exe https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.1.6-1/rubyinstaller-devkit-3.1.6-1-x64.exe
RUN cmd /c rubyinstaller-devkit-3.1.6-1-x64.exe -o"c:\DevKit64" -y

RUN choco install -y git \
    && choco install -y msys2 --params "'/NoPath /NoUpdate /InstallDir:C:\msys64'"
# pacman -Syu --noconfirm is needed for downloading ucrt64 repo.
# They should be removed after using Ruby 2.5.9, 2.6.7, and 2.7.3 installers.
RUN refreshenv \
    && C:\ruby31-x64\bin\ridk exec pacman -Syu --noconfirm \
    && C:\ruby31-x64\bin\ridk install 2 3

ENTRYPOINT ["cmd"]
