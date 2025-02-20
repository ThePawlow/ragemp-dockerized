# Dockerized RageMP Server
## Usage
https://hub.docker.com/r/thepavlov/ragemp-dockerized

```
docker pull thepavlov/ragemp-dockerized
```
## With or without DotNet. You decide!
**Without DotNet** latest

**With DotNet** latest-dotnet*

_*runs .NET 8.0 LTS for security reasons_

## Mounting
Server Files are under **/opt/ragemp/**

Files you might want to mount
- /opt/ragemp/resources
- /opt/ragemp/conf.json

## Credits
Based off https://github.com/BamButz/docker-ragemp

Edited to be more secure and support DotNet
