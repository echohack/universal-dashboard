$pkg_name="universal-dashboard"
$pkg_origin="echohack"
$pkg_version="1.0.0"
$pkg_license=('MIT')
$pkg_upstream_url="https://www.microsoft.com/net/core"
$pkg_description=".NET Core is a blazing fast, lightweight and modular platform
  for creating web applications and services that run on Windows,
  Linux and Mac."
$pkg_maintainer="The Habitat Maintainers <humans@habitat.sh>"
$pkg_deps=@(
    "core/node"
    "core/dotnet-core-sdk"
    "core/dotnet-472-runtime"
)
$pkg_bin_dirs=@("bin")