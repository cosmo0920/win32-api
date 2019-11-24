## Prerequisites

* Docker for Windows

### Release step

Check the latest ruby-head-YYYYmmDD image:
https://hub.docker.com/r/cosmo0920/win32-api/tags?page=1&name=ruby-head

```powershell
PS> mkdir pkg
PS> docker run -it -v $PWD\pkg:C:\pkg cosmo0920/win32-api:ruby-head-AWESOMEDATE
```

Build universal gem:

```cmd
> .\build-gem.bat
```

Copy built universal gem into mounted directory:

```cmd
> copy C:\win32-api\win32-api-*.gem C:\pkg
```

Then, exit and push built gem:

```cmd
> exit
> gem push win32-api-*.gem
```
