#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src

RUN apt-get update && apt-get install -y \
    openjdk-11-jre-headless

RUN apt-get clean

COPY ["TestAPIDeplo/TestAPIDeplo.csproj", "TestAPIDeplo/"]
COPY ["TestApiDeployTest/TestApiDeployTest.csproj", "TestApiDeployTest/"]
COPY . .

RUN dotnet restore "TestAPIDeplo/TestAPIDeplo.csproj"
RUN dotnet restore "TestApiDeployTest/TestApiDeployTest.csproj"

WORKDIR "/src"
ENV PATH="$PATH:/root/.dotnet/tools"
RUN dotnet tool install --global dotnet-sonarscanner
RUN dotnet sonarscanner begin /n:"testapideployproject" /k:"testapideployproject" /d:sonar.host.url=https://sonarcloud.io /d:sonar.login="64b9c959d388e78cafcbbc26510ba1f17848082f"
RUN dotnet build
RUN dotnet sonarscanner end /d:sonar.login="64b9c959d388e78cafcbbc26510ba1f17848082f"




FROM build AS publish
WORKDIR "/src/TestAPIDeplo"
RUN dotnet publish "TestAPIDeplo.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TestAPIDeplo.dll"]