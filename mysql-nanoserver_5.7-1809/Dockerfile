FROM mcr.microsoft.com/powershell:nanoserver-1809

USER ContainerAdministrator

LABEL maintainer "Denis Shatohin"

ENV MYSQL_ROOT_PWD="_" \
    DB_NAME="_" \
	DB_USER="_" \
	DB_USER_PWD="_" \
    MYSQL_PWD_PATH="C:\ProgramData\Docker\secrets\sa-password"

ENV vcredist_url="https://download.microsoft.com/download/2/E/6/2E61CFA4-993B-4DD4-91DA-3737CD5CD6E3/vcredist_x64.exe" \
    mysql_url="https://dev.mysql.com/get/Downloads/MySQL-5.7/mysql-5.7.27-winx64.zip" \
    servicemonitor_url="https://dotnetbinaries.blob.core.windows.net/servicemonitor/2.0.1.6/ServiceMonitor.exe"

SHELL ["pwsh", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'Continue'; $verbosePreference='Continue';"]

COPY start.ps1 /

WORKDIR /

RUN Invoke-WebRequest $env:vcredist_url -OutFile "vcredist.exe" ; \
    .\vcredist.exe /Q ; \
	Start-Sleep -s 5 ; \
    Remove-Item  "vcredist.exe" -Force 

RUN Invoke-WebRequest $env:mysql_url -OutFile "mysql.zip" ; \
    Expand-Archive "mysql.zip" "C:\." ; \
    Rename-Item "C:\mysql-5.7.27-winx64" "C:\MySQL" ; \
    Remove-Item "mysql.zip" -Force

RUN Set-Content "C:\MySQL\my.ini" '[mysqld]`r`nbasedir=""C:\MySQL""`r`ndatadir=""C:\MySQL\DATA""`r`nexplicit_defaults_for_timestamp=1' ; \
    New-Item "C:\MySQL\DATA" -ItemType "Directory" | Out-Null ; \
    "C:\MySQL\bin\mysqld.exe" --initialize-insecure ; \
    "C:\MySQL\bin\mysqld.exe --install

RUN Invoke-WebRequest $env:servicemonitor_url -OutFile "C:\ServiceMonitor.exe"

EXPOSE 3306 33060

CMD pwsh.exe .\start.ps1 -MYSQL_ROOT_PWD $env:MYSQL_ROOT_PWD -DB_NAME $env:DB_NAME -DB_USER $env:DB_USER -DB_USER_PWD $env:DB_USER_PWD -Verbose