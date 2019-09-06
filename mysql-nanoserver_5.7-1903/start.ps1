Param(
[Parameter(Mandatory=$false)]
[String]$MYSQL_ROOT_PWD,

[Parameter(Mandatory=$false)]
[String]$DB_NAME,

[Parameter(Mandatory=$false)]
[String]$DB_USER,

[Parameter(Mandatory=$false)]
[String]$DB_USER_PWD
)

$env:Path += ";C:\MySQL\bin"
setx Path $env:Path /m

Write-Verbose "Starting MySQL Server"
Start-Service MySQL

if(($DB_NAME -ne "_") -and ($DB_USER -ne "_") -and ($DB_USER_PWD -ne "_"))
{
    Write-Verbose "Creating database $DB_NAME"
    $DB_INIT = "CREATE DATABASE" + " $DB_NAME " + "DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;" `
    + "GRANT ALL ON" + " $DB_NAME.* " + "to" + " '$DB_USER'@'%' IDENTIFIED BY" + " '" + $DB_USER_PWD + "';" `
    + "FLUSH PRIVILEGES;"
    mysql --user=root --execute="$DB_INIT"
}

if($MYSQL_ROOT_PWD -eq "_") {
    $secretPath = $env:MYSQL_PWD_PATH
    if (Test-Path $secretPath) {
        $MYSQL_ROOT_PWD = Get-Content -Raw $secretPath
    }
    else {
        Write-Verbose "WARN: Using default MySQL root password, secret file not found at: $secretPath"
    }
}

if($MYSQL_ROOT_PWD -ne "_")
{
    Write-Verbose "Changing MySQL root password"
    $MYSQL_INIT = "ALTER USER 'root'@'localhost' IDENTIFIED BY" + " '" + $MYSQL_ROOT_PWD + "';" `
    + "GRANT ALL ON *.* to root@'%' IDENTIFIED BY" + " '" + $MYSQL_ROOT_PWD + "';" `
    + "FLUSH PRIVILEGES;"
    mysql --user=root --execute="$MYSQL_INIT"
}

C:\ServiceMonitor.exe "mysql"