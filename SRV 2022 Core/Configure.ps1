$ous = @{ enterprise='';prod='enterprise';direction='enterprise' }
$users = @{ bob='prod';alice='prod';jean='direction';pierre='direction'}
$ous.GetEnumerator() | Sort-Object {$_.Value} | ForEach-Object {
    if ($_.Value -eq '') {
        New-ADOrganizationalUnit -name $_.Key -Path "DC=ais,DC=labo"
        New-ADGroup -Name $("gg_" + $_.Key) -Path $("OU=" + $_.Key + ",DC=ais,DC=labo") -GroupCategory Security -GroupScope Global
    }
    else {
        New-ADOrganizationalUnit -name $_.key -Path $("OU=" + $_.Value + ",DC=ais,DC=labo")
        New-ADOrganizationalUnit -name utilisateurs -Path $("OU=" + $_.Key + ",OU=" + $_.Value + ",DC=ais,DC=labo")
        New-ADOrganizationalUnit -name ordinateurs -Path $("OU=" + $_.Key + ",OU=" + $_.Value + ",DC=ais,DC=labo")
        New-ADGroup -Name $("gg_" + $_.Key) -Path $("OU=" + $_.Key + ",OU=" + $_.Value + ",DC=ais,DC=labo") -GroupCategory Security -GroupScope Global
        Add-ADGroupMember -Identity $("gg_" + $_.Value) -Members $("gg_" + $_.Key)
    }
}
$users.GetEnumerator() | ForEach-Object {
        New-ADUser -Name $_.Key -DisplayName $_.Key -GivenName $_.Key -AccountPassword $(ConvertTo-SecureString -AsPlainText -Force "0Poseidon") -Path $("OU=utilisateurs," + $(get-adorganizationalUnit -Filter 'name -like $_.Value').distinguishedname) -Enabled 1 -UserPrincipalName $($_.Key + "@ais.labo") -PasswordNeverExpires 1
        Add-ADGroupMember -Identity $("gg_" + $_.Value) -Members $_.Key

}

