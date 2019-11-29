# Assuming you have all your agents storing their deployment journal at C:\Octopus\DeploymentJournal.xml
# Assuming you have a variable defined as InstallationRoot which is the Root installation folder
# (e.g. you may actually deploy to #{InstallationRoot}\#{Octopus.Release.Number})

$InstallationRoot = $($OctopusParameters['InstallationRoot'])
$ProjectId = $OctopusParameters["Octopus.Project.Id"]
$EnvironmentId = $OctopusParameters["Octopus.Environment.Id"]
$ReleasesToKeep = $($OctopusParameters['OctopusRetentionPolicyItemsToKeep'])

$PathToDeploymentJournal="C:\Octopus\DeploymentJournal.xml"

$DeploymentXPath="/Deployments/Deployment[@ProjectId='$ProjectId' and @EnvironmentId='$EnvironmentId' and @WasSuccessful='True']"

$Deployments = Select-Xml -Path $PathToDeploymentJournal -XPath $DeploymentXPath 

$InstallationFoldersToKeep = $Deployments `
    | Select-Object -ExpandProperty Node `
    | sort { [DateTime]$_.InstalledOn } `
    | select -Last $ReleasesToKeep `
    | % {$_.CustomInstallationDirectory}


$CurrentDirectories = Get-ChildItem $InstallationRoot -Directory | % FullName

$FoldersToDelete = $CurrentDirectories | where { $InstallationFoldersToKeep -notcontains $_ }

cls

Write-Host "Cleaning Installation Directories"
Write-Host "---------------------------------"
Write-Host
Write-Host "InstallationRoot:$InstallationRoot Project:$ProjectId Environment:$EnvironmentId ReleasesToKeep:$ReleasesToKeep"
Write-Host "--------------------------------------------------------------"
Write-Host
Write-Host "Installation Root: $InstallationRoot"
Write-Host "Keeping $ReleasesToKeep Installations"
Write-Host
Write-Host "Keeping ..."
Write-Host "-----------"
$InstallationFoldersToKeep
Write-Host
Write-Host "Removing ..."
Write-Host "------------"
$FoldersToDelete

$FoldersToDelete | Remove-Item -force -recurse
