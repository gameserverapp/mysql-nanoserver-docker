Param(
[Parameter(Mandatory=$false)]
[String]$MYSQL_ROOT_PWD
)

Write-Verbose "Setting PATH for MySQL Server"
$env:Path += ";C:\MySQL\bin"
setx Path $env:Path /m

Write-Verbose "Starting MySQL Server"
Start-Service MySQL

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

Write-Verbose "Started MySQL Server"

$LastCheck = (Get-Date).AddSeconds(-2) 
while ($true) 
{ 
    Get-WinEvent -FilterHashtable @{ ProviderName='MySQL'; StartTime=$LastCheck } | Select-Object TimeCreated, LevelDisplayName, Message	 
    $LastCheck = Get-Date 
    Start-Sleep -Seconds 2 
}