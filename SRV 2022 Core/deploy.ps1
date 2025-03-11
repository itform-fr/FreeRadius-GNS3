$Carte=$(Get-NetAdapter).name
$Adresse="192.168.50.250"
$Passerelle="192.168.50.254"
$Domaine="ais.labo"
New-ItemProperty -Path "HKLM\SYSTEM\CurrentControlSet\Services\NlaSvc\Parameters" -Name "AlwaysExpectDomainController" -Value 1 -PropertyType DWord -Force
Set-NetIPInterface -InterfaceAlias $Carte -Dhcp Disabled
New-NetIPAddress -InterfaceAlias $Carte -IPAddress $Adresse -PrefixLength 24 -DefaultGateway $Passerelle
Install-WindowsFeature ad-domain-services
Install-ADDSForest -DomainName $Domaine -SafeModeAdministratorPassword $(ConvertTo-SecureString -Force -AsPlainText "0Poseidon")  -confirm:$false

