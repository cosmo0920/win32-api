FROM mcr.microsoft.com/windows/servercore:20H2
LABEL maintainer "Hiroshi Hatake <cosmo0920.wp@gmail.com>"
LABEL Description="win32-api building docker image"

# Do not split this into multiple RUN!
# Docker creates a layer for every RUN-Statement
RUN powershell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

# Ruby 2.0.0
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.0.0-p648.exe https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.0.0-p648.exe
RUN cmd /c "C:\rubyinstaller-2.0.0-p648.exe" /silent /dir=c:\ruby200
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.0.0-p648-x64.exe https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.0.0-p648-x64.exe
RUN cmd /c "C:\rubyinstaller-2.0.0-p648-x64.exe" /silent /dir=c:\ruby200-x64
# Ruby 2.1
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.1.9.exe https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.1.9.exe
RUN cmd /c "C:\rubyinstaller-2.1.9.exe" /silent /dir=c:\ruby21
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.1.9-x64.exe https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.1.9-x64.exe
RUN cmd /c "C:\rubyinstaller-2.1.9-x64.exe" /silent /dir=c:\ruby21-x64
# Ruby 2.2
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.2.6.exe https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.2.6.exe
RUN cmd /c "C:\rubyinstaller-2.2.6.exe" /silent /dir=c:\ruby22
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.2.6-x64.exe https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.2.6-x64.exe
RUN cmd /c "C:\rubyinstaller-2.2.6-x64.exe" /silent /dir=c:\ruby22-x64
# Ruby 2.3
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.3.3.exe https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.3.3.exe
RUN cmd /c "C:\rubyinstaller-2.3.3.exe" /silent /dir=c:\ruby23
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.3.3-x64.exe https://dl.bintray.com/oneclick/rubyinstaller/rubyinstaller-2.3.3-x64.exe
RUN cmd /c "C:\rubyinstaller-2.3.3-x64.exe" /silent /dir=c:\ruby23-x64
# Ruby 2.4
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.4.9-1-x86.exe https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.4.9-1/rubyinstaller-2.4.9-1-x86.exe
RUN cmd /c "C:\rubyinstaller-2.4.9-1-x86.exe" /silent /dir=c:\ruby24
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.4.9-1-x64.exe https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.4.9-1/rubyinstaller-2.4.9-1-x64.exe
RUN cmd /c "C:\rubyinstaller-2.4.9-1-x64.exe" /silent /dir=c:\ruby24-x64
# Ruby 2.5
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.5.7-1-x86.exe https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.5.7-1/rubyinstaller-2.5.7-1-x86.exe
RUN cmd /c "C:\rubyinstaller-2.5.7-1-x86.exe" /silent /dir=c:\ruby25
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.5.7-1-x64.exe https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.5.7-1/rubyinstaller-2.5.7-1-x64.exe
RUN cmd /c "C:\rubyinstaller-2.5.7-1-x64.exe" /silent /dir=c:\ruby25-x64
# Ruby 2.6
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.6.5-1-x86.exe https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.5-1/rubyinstaller-2.6.5-1-x86.exe
RUN cmd /c "C:\rubyinstaller-2.6.5-1-x86.exe" /silent /dir=c:\ruby26
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.6.5-1-x64.exe https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.6.5-1/rubyinstaller-2.6.5-1-x64.exe
RUN cmd /c "C:\rubyinstaller-2.6.5-1-x64.exe" /silent /dir=c:\ruby26-x64

# Ruby 2.7
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.7.0-1-x86.exe https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.0-1/rubyinstaller-2.7.0-1-x86.exe
RUN cmd /c "C:\rubyinstaller-2.7.0-1-x86.exe" /silent /dir=c:\ruby27
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-2.7.0-1-x64.exe https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-2.7.0-1/rubyinstaller-2.7.0-1-x64.exe
RUN cmd /c "C:\rubyinstaller-2.7.0-1-x64.exe" /silent /dir=c:\ruby27-x64

# Ruby 3.0
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-3.0.0-1-x86.exe https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.0-1/rubyinstaller-3.0.0-1-x86.exe
RUN cmd /c "C:\rubyinstaller-3.0.0-1-x86.exe" /silent /dir=c:\ruby30
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\rubyinstaller-3.0.0-1-x64.exe https://github.com/oneclick/rubyinstaller2/releases/download/RubyInstaller-3.0.0-1/rubyinstaller-3.0.0-1-x64.exe
RUN cmd /c "C:\rubyinstaller-3.0.0-1-x64.exe" /silent /dir=c:\ruby30-x64

# DevKit
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe https://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe
RUN cmd /c C:\DevKit-mingw64-32-4.7.2-20130224-1151-sfx.exe -o"c:\DevKit" -y
RUN powershell \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -OutFile C:\DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe https://dl.bintray.com/oneclick/rubyinstaller/DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe
RUN cmd /c C:\DevKit-mingw64-64-4.7.2-20130224-1432-sfx.exe -o"c:\DevKit64" -y

RUN choco install -y git \
    && choco install -y msys2 --params "'/NoPath /NoUpdate /InstallDir:C:\msys64'"
# pacman -Syu --noconfirm is needed for downloading ucrt64 repo.
# They should be removed after using Ruby 2.5.9, 2.6.7, and 2.7.3 installers.
RUN refreshenv \
    && C:\ruby27\bin\ridk exec pacman -Syu --noconfirm \
    && C:\ruby27\bin\ridk install 2 3 \
    && C:\ruby27-x64\bin\ridk exec pacman -Syu --noconfirm \
    && C:\ruby27-x64\bin\ridk install 2 3

ENTRYPOINT ["cmd"]
