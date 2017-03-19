
cd .\automatic
Get-ChildItem */* | 
where {$_.name -eq "update.ps1"} | 
foreach { cd $_.DirectoryName; mvn clean compile; cd ..}
