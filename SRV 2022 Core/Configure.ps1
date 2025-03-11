$ous = @{ enterprise='';prod='enterprise';direction='enterprise' }
$users = @{ bob='prod';alice='prod';jean='direction';pierre='direction'}
$ous.GetEnumerator() | Sort-Object {$_.Value} | ForEach-Object {
    if ($_.Value -eq '') {
        New-ADOrganisationalUnit -name $_.Key -Path "DC=ais,DC=labo"
        New-ADGroup -Name $("gg_" + $_.Key) -Path $($_.Key + ",DC=ais,DC=labo") -GroupCategory Security -GroupScope Global
    }
    else {
        New-ADOrganisationalUnit -name $_.key -Path $("OU=" + $_.Value + ",DC=ais,DC=labo")
        New-ADGroup -Name $("gg_" + $_.Key) -Path $("OU=" + $_.Key + ",OU=" + $_.Value + ",DC=ais,DC=labo") -GroupCategory Security -GroupScope Global
        Add-ADGroupMember -Identity $("gg_" + $_.Value) -Members $("gg_" + $_.Key)
    }
}
$users.GetEnumerator() | ForEach-Object {
        New-ADUser -Name $_.Key -DisplayName $_.Key -GivenName $_.Key -AccountPassword $(ConvertTo-SecureString -AsPlainText -Force "0Poseidon") -Path $("OU=utilisateurs," + $(get-adorganisationalUnit -Filter 'name -like $_.Value').distinguishedname) -Enabled 1 -UserPrincipalName $($_.Key + "@ais.labo") -PasswordNeverExpires 1
        New-ADOrganisationalUnit -name $_.Key -Path "DC=ais,DC=labo"

}

