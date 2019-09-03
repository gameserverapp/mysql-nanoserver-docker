FROM mcr.microsoft.com/powershell:nanoserver-1809

USER ContainerAdministrator

LABEL maintainer "Denis Shatohin"

ENV MYSQL_ROOT_PWD="_" \
    MYSQL_PWD_PATH="C:\ProgramData\Docker\secrets\sa-password"

ENV vcredist_url "https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe"
ENV mysql_url "https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.26-winx64.zip"


SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]
COPY start.ps1 /
WORKDIR /

RUN Invoke-WebRequest -Uri $env:vcredist_url -OutFile vcredist_x64.exe ; \
        .\vcredist_x64.exe /Q ; \
        Remove-Item -Force vcredist_x64.exe

RUN Invoke-WebRequest "$env:mysql_url" -OutFile "mysql.zip" ; \
    Expand-Archive mysql.zip C:\ ; \
    Rename-Item C:\mysql-5.7.26-winx64 C:\MySQL

RUN Set-Content "C:\MySQL\my.ini" "[mysqld]`r`nbasedir=""C:\MySQL""`r`ndatadir=""C:\MySQL\DATA""`r`nexplicit_defaults_for_timestamp=1" ; \
    New-Item C:\MySQL\DATA -ItemType "Directory" | Out-Null ; \
    .\MySQL\bin\mysqld.exe --initialize-insecure ; \
    .\MySQL\bin\mysqld.exe --install ; \
    Remove-Item -Force mysql.zip

EXPOSE 3306 33060

CMD pwsh.exe .\start.ps1 -MYSQL_ROOT_PWD $env:MYSQL_ROOT_PWD -Verbose