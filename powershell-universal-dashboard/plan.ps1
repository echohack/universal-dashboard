$pkg_name="universal-dashboard"
$pkg_origin="echohack"
$pkg_version="release.20190529.7"
$pkg_license=('MIT')
$pkg_upstream_url="https://www.microsoft.com/net/core"
$pkg_description=".NET Core is a blazing fast, lightweight and modular platform
  for creating web applications and services that run on Windows,
  Linux and Mac."
$pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
$pkg_source="https://github.com/ironmansoftware/universal-dashboard/archive/$pkg_version.zip"
$pkg_shasum="2eb164e8aef240a045f9440f7a5f4ab898ab1fe4567425aef68e162d80651942"
$pkg_build_deps=@(
    "core/powershell"
    "core/dotnet-472-dev-pack"
)
$pkg_deps=@(
    "core/node"
    "core/dotnet-core-sdk"
    "core/dotnet-472-runtime"
)
$pkg_bin_dirs=@("bin")

function Invoke-SetupEnvironment {
  # TODO: Fix this broken junk
  Set-BuildtimeEnv "DOTNET_ROOT" "$(Get-HabPackagePath dotnet-core-sdk)\bin" -Force
  # Set-BuildtimeEnv "$env:BuildDir" "$HAB_CACHE_SRC_PATH\$pkg_dirname\$pkg_dirname\src" -Force
}

function Invoke-Prepare {
  # New-Item -Path "Habitat:\hab\bin\powershell.bat" -ItemType SymbolicLink -Value "$(Get-HabPackagePath powershell)\bin\" -Force

  $powershell = @"
@echo off
REM source='C:\hab\pkgs\core\powershell\6.2.1\20190621130612\bin\pwsh.exe'
"C:\hab\pkgs\core\powershell\6.2.1\20190621130612\bin\pwsh.exe" %*
"@

  $powershell | Out-File -FilePath "Habitat:\hab\bin\powershell.bat"
  # TODO: Fix this broken junk
    Set-BuildtimeEnv "$env:BuildDir" "$HAB_CACHE_SRC_PATH\$pkg_dirname\$pkg_dirname\src" -Force

}

function Invoke-Build {
  $Configuration="Release"
  Set-BuildtimeEnv "$env:BuildDir" "$HAB_CACHE_SRC_PATH\$pkg_dirname\$pkg_dirname\src" -Force


  $platyPS = Import-Module platyPS  -PassThru -ErrorAction Ignore
  if ($platyPS -eq $null) {
    Install-Module platyPS -Scope CurrentUser -Force
    Import-Module platyPS -Force
  }

  dotnet tool install CycloneDX --tool-path "C:\hab\bin\"
  dotnet CycloneDX "$env:BuildDir\UniversalDashboard.Sln" -o ".\"

  Rename-Item "bom.xml" "dotnet.bom.xml"

  dotnet publish -c $Configuration "$env:BuildDir\UniversalDashboard\UniversalDashboard.csproj" -f netstandard2.0
  dotnet publish -c $Configuration "$env:BuildDir\UniversalDashboard.Server\UniversalDashboard.Server.csproj" -f netstandard2.0
  dotnet publish -c $Configuration "$env:BuildDir\UniversalDashboard\UniversalDashboard.csproj" -f net472
  dotnet publish -c $Configuration "$env:BuildDir\UniversalDashboard.Server\UniversalDashboard.Server.csproj" -f net472

  # Push-Location "$env:BuildDir\client"
  # npm install
  # npm install -g @cyclonedx/bom
  # cyclonedx-bom -o core.bom.xml
  # npm run build
  # Pop-Location

# # Build Child Modules

# Push-Location "$env:BuildDir\UniversalDashboard.Materialize"
# .\build.ps1
# Pop-Location

# Push-Location "$env:BuildDir\UniversalDashboard.MaterialUI"
# .\build.ps1
# Pop-Location

# # End Build Child Modules

# $outputDirectory = Join-Path $env:BuildDir "output"
# if ((Test-Path $outputDirectory)) {
# 	Remove-Item $outputDirectory -Force -Recurse
# }

# New-Item -ItemType Directory $outputDirectory

# $bomDirectory = Join-Path $env:BuildDir "boms"
# if ((Test-Path $bomDirectory)) {
# 	Remove-Item $bomDirectory -Force -Recurse
# }

# New-Item -ItemType Directory $bomDirectory


# $net472 = Join-Path $outputDirectory "net472"
# $netstandard20 = Join-Path $outputDirectory "netstandard2.0"
# $help = Join-Path $outputDirectory "en-US"
# $client = Join-Path $outputDirectory "client"
# $poshud = Join-Path $outputDirectory "poshud"
# $childModules = Join-Path $outputDirectory "Modules"

# New-Item -ItemType Directory $net472
# New-Item -ItemType Directory $netstandard20
# New-Item -ItemType Directory $help
# New-Item -ItemType Directory $client
# New-Item -ItemType Directory $childModules

# Copy-Item "$env:BuildDir\UniversalDashboard\bin\$Configuration\netstandard2.0\publish\*" $netstandard20 -Recurse
# Copy-Item "$env:BuildDir\UniversalDashboard\bin\$Configuration\net472\publish\*" $net472 -Recurse

# Copy-Item "$env:BuildDir\client\src\public\*" $client -Recurse

# Copy-Item "$env:BuildDir\UniversalDashboard.Server\bin\$Configuration\netstandard2.0\publish\UniversalDashboard.Server.dll" $netstandard20
# Copy-Item "$env:BuildDir\UniversalDashboard.Server\bin\$Configuration\netstandard2.0\publish\UniversalDashboard.Server.deps.json" $netstandard20
# Copy-Item "$env:BuildDir\UniversalDashboard.Server\bin\$Configuration\netstandard2.0\publish\DasMulli.Win32.ServiceUtils.dll" $netstandard20

# Copy-Item "$env:BuildDir\UniversalDashboard.Server\bin\$Configuration\net472\publish\UniversalDashboard.Server.exe" $net472
# Copy-Item "$env:BuildDir\UniversalDashboard.Server\bin\$Configuration\net472\publish\UniversalDashboard.Server.exe.config" $net472
# Copy-Item "$env:BuildDir\UniversalDashboard.Server\bin\$Configuration\net472\publish\DasMulli.Win32.ServiceUtils.dll" $net472

# Copy-Item "$env:BuildDir\web.config" $outputDirectory
# Copy-Item "$env:BuildDir\UniversalDashboard\UniversalDashboard.psm1" $outputDirectory
# Copy-Item "$env:BuildDir\UniversalDashboard\UniversalDashboardServer.psm1" $outputDirectory
# Copy-Item "$env:BuildDir\UniversalDashboard\bin\$Configuration\net472\UniversalDashboard.Controls.psm1" $outputDirectory
# Copy-Item "$env:BuildDir\poshud" $poshud -Recurse -Container

# Copy-Item "$env:BuildDir\..\LICENSE" "$outputDirectory\LICENSE.txt"

# # Copy Child Modules

# Copy-Item "$env:BuildDir\UniversalDashboard.Materialize\output\UniversalDashboard.Materialize" $childModules -Recurse -Container
# Copy-Item "$env:BuildDir\UniversalDashboard.MaterialUI\output\UniversalDashboard.MaterialUI" $childModules -Recurse -Container

# # End Copy Child Modules

# . "$env:BuildDir\CorFlags.exe" /32BITREQ-  "$outputDirectory\net472\UniversalDashboard.Server.exe"

# . (Join-Path $env:BuildDir 'UniversalDashboard\New-UDModuleManifest.ps1') -outputDirectory $outputDirectory

# if (-not $NoHelp) {
# 	New-ExternalHelp -Path "$env:BuildDir\UniversalDashboard\Help" -OutputPath "$help\UniversalDashboard.Community-help.xml"
# }

# Get-ChildItem $env:BuildDir -Include "*.bom.xml" -Recurse | ForEach-Object { Copy-Item $_.FullName ".\boms" }
    # & "$HAB_CACHE_SRC_PATH/$pkg_dirname/$pkg_dirname/src/build.ps1"
}




# function Invoke-Install {
#   Copy-Item * "$pkg_prefix/bin" -Recurse -Force
# }

# function Invoke-Check() {
#   mkdir dotnet-new
#   Push-Location dotnet-new
#   ../dotnet.exe new web
#   if(!(Test-Path "program.cs")) {
#     Pop-Location
#     Write-Error "dotnet app was not generated"
#   }
#   Pop-Location
#   Remove-Item -Recurse -Force dotnet-new
# }
