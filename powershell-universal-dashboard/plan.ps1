$pkg_name="powershell-universal-dashboard"
$pkg_origin="echohack"
$pkg_version="20190529.7"
$pkg_license=('MIT')
$pkg_upstream_url="https://www.microsoft.com/net/core"
$pkg_description=".NET Core is a blazing fast, lightweight and modular platform
  for creating web applications and services that run on Windows,
  Linux and Mac."
$pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
$pkg_source="https://github.com/ironmansoftware/universal-dashboard/archive/release.$pkg_version.zip"
$pkg_shasum="4a83be23efaed263f6a1fa07bd144c0a590e08d0e40d464550e0c3ec87e4f77d"
$pkg_deps=@(
    "core/node"
    "core/dotnet-core-sdk"
)
$pkg_bin_dirs=@("bin")

function Invoke-Build {
    $pkg_source/src/build.ps1
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
