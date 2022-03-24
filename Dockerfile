#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM default-route-openshift-image-registry.apps.cluster-jzc2c.jzc2c.sandbox505.opentlc.com/myapp1/3.1-buster-slim AS base
ENV ASPNETCORE_URLS=http://*:8080
WORKDIR /app
EXPOSE 8080

FROM default-route-openshift-image-registry.apps.cluster-jzc2c.jzc2c.sandbox505.opentlc.com/myapp1/3.1-buster AS build
WORKDIR /app
COPY DockerDemo.csproj .
RUN dotnet restore
COPY . .
RUN dotnet build -c Release

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerDemo.dll"]
