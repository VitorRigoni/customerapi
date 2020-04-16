#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
COPY ["src/CustomerApi/CustomerApi.csproj", "src/CustomerApi/CustomerApi.csproj"]
COPY ["Nuget.config", "Nuget.config"]
RUN dotnet restore "src/CustomerApi/CustomerApi.csproj"
COPY . .
RUN dotnet build "src/CustomerApi/CustomerApi.csproj" -c Release -o /app/build --no-restore

FROM build AS publish
RUN dotnet publish "src/CustomerApi/CustomerApi.csproj" -c Release -o /app/publish --no-restore

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "CustomerApi.dll"]