FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app
COPY . .

RUN dotnet restore

# Add packages

RUN dotnet add package Google.Cloud.Firestore
RUN dotnet add package Grpc.Net.Client
RUN dotnet add package Newtonsoft.Json


RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/out ./
ENTRYPOINT ["dotnet", "PhishTankGCPRun.dll"]
