For an organisation using GitHub and releasing Scala artifacts to Maven Central,
[`gha-scala-library-release-workflow`](https://github.com/guardian/gha-scala-library-release-workflow) provides many
benefits, including some that are novel over the current state of the art.

### Particularly novel features!

* **better security for release credentials** by isolating release phases into separate GitHub Workflow Jobs - the
  build, test, and assembly phases [don't have access to those credentials](security-design.md) 🔒
* **automated version compatibility checking**, detecting binary & source incompatibilities, and setting
  [SemVer-compliant](https://docs.scala-lang.org/overviews/core/binary-compatibility-for-library-authors.html#versioning-scheme---communicating-compatibility-breakages)
  version numbers automatically - allowing sbt to reliably
  [block dependency clashes that cause runtime errors](https://github.com/guardian/facia-scala-client/issues/301) 🎉


### Benefits which are just, like, nicely implemented

Compared to just running `sbt release` on a developer laptop, some of these benefits can be seen with other CI-based
release workflows. They were highly prized in the development of `gha-scala-library-release-workflow`:

* **reduced configuration** - per-repo config is much reduced by one-off organisation-level config.
  Good defaults further reduce sbt configuration 🧹
* **zero developer onboarding** - no need for a new dev to get Sonatype credentials or PGP keys. If they can write
  to the repo, they can release! 🚀
* **preview releases** for Pull Requests (https://github.com/guardian/gha-scala-library-release-workflow/pull/19) 👭🏻
* **automatic GitHub Release notes** - always worth having these 📝
