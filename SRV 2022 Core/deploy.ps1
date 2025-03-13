<#
$Carte=$(Get-NetAdapter).name
$Adresse="192.168.50.250"
$Passerelle="192.168.50.254"
$Domaine="ais.labo"

Set-NetIPInterface -InterfaceAlias $Carte -Dhcp Disabled
New-NetIPAddress -InterfaceAlias $Carte -IPAddress $Adresse -PrefixLength 24 -DefaultGateway $Passerelle
#>
curl -o c:\configure.ps1 https://raw.githubusercontent.com/itform-fr/FreeRadius-GNS3/refs/heads/main/SRV%202022%20Core/Configure.ps1
Install-WindowsFeature ad-domain-services
Install-ADDSForest -DomainName ais.labo -SafeModeAdministratorPassword $(ConvertTo-SecureString -Force -AsPlainText "0Poseidon")  -confirm:$false

