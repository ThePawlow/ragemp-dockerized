# Build without .NET
# Size 684 MB
docker build --build-arg DOTNET=false -t ragemp-dockerized:latest -t ragemp-dockerized:v1.0 .

# Build with .NET
# Size 763 MB
# Difference of 79 MB
docker build --build-arg DOTNET=true -t ragemp-dockerized:latest-dotnet -t ragemp-dockerized:v1.0-dotnet .