oh-my-posh init pwsh --config "$env:HOME/.oh-my-posh/themes/jasperes.dracula.omp.json" | Invoke-Expression

Import-Module Terminal-Icons
Import-Module PSReadLine

Set-PSReadlineKeyHandler -Key Ctrl+Spacebar -Function MenuComplete
Set-PSReadLineOption -PredictionViewStyle ListView
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward
