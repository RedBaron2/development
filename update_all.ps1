
cd .\automatic
Get-ChildItem */* | 
where {$_.name -eq "update.ps1"} | 
foreach { cd $_.DirectoryName; .\update.ps1; cd ..}

cd ..
cd .\test
updateall
