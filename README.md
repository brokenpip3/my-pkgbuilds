# My aur pkgbuilds

This repo contains all the archlinux aur [packages](https://aur.archlinux.org/packages?O=0&SeB=m&K=brokenpip3&outdated=&SB=p&SO=d&PP=50&submit=Go) that I maintain.


## CI

* [PR workflow](.github/workflows/pr.yaml) that analyze every PR and try to build any modified package.

* [Auto update workflow](.github/workflows/auto-check-updates.yaml) that checks if the upstream version is changed (only the
  sources that are hosted on `github.com` atm) and in that case will try to
  build the package. If the packages builds successfully the flow will
  automatically create a PR ([example](https://github.com/brokenpip3/my-pkgbuilds/pull/2)) for that single package.

* [Auto push workflow](.github/workflows/auto-push-updates.yaml) that will push automatically the package update to aur after the PR will be merged.

PRs are welcome!
