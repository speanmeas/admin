# activate project .venv (exit if missing or activation failed)
$activate = Join-Path $PSScriptRoot ".venv\Scripts\Activate.ps1"
if (-not (Test-Path -LiteralPath $activate)) {
    Write-Error ".venv not found: $activate"
    exit 1
}
& $activate
if (-not $env:VIRTUAL_ENV) {
    Write-Error ".venv activation failed"
    exit 1
}

# auto commit and push changes to git
git add .
git commit -m "update"
git push
