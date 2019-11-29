# Octopus.CustomInstallationDirectory.RetentionPolicy
Apply Retention Policy to Custom Installation Directory in Octopus

Octopus stores the custom installation directory if you use it but does not apply the retention policy for some reason.

The powershell script in this repo checks the deployment journal, gets the number of releases to keep from your retention policy setting and then deletes any other folders that are subfolders of ${InstallationRoot}.

N.B. You must have a Variable called InstallationRoot under which you deploy. I tend to deploy to {InstallationRoot}\{ReleaseId}.
