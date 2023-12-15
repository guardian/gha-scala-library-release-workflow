# GHA Scala Library Release Workflow
_Publishing Scala libraries to Maven Central using GitHub Actions (GHA), keeping release credentials isolated securely from the library build_

The [`reusable-release.yml`](https://github.com/guardian/gha-scala-library-release-workflow/blob/main/.github/workflows/reusable-release.yml) workflow puts the stages of publishing your library to Maven Central
into separate workflow [jobs](https://docs.github.com/en/actions/using-jobs/using-jobs-in-a-workflow):

![image](https://github.com/guardian/gha-scala-library-release-workflow/assets/52038/3d229ccd-e60f-44f7-86e7-0e607134e47b)

The individual workflow jobs can be distingushed in their level of trust - what code they execute:

* 🎊 Library build/test code - the _shiny & unknown_ wonders falling out of the confetti ball symbolise the potentially dangerous code coming from the library's transitive dependencies
* 🔒 Fixed code that's dictated by `gha-scala-library-release-workflow` - trusted with release credentials and write access on the repository

This means your library's code, with its tests and dependencies, does **NOT** have access to your release credentials:

* [Sonatype OSSRH](https://central.sonatype.org/publish/publish-guide/) username & password
* [PGP signing key](https://central.sonatype.org/publish/requirements/gpg/)

So while the library's code is being compiled, its tests run, and artifacts created, there is no way for malicious code to
[exfiltrate](https://www.synacktiv.com/en/publications/cicd-secrets-extraction-tips-and-tricks) those secrets.

### Examples

* https://github.com/guardian/facia-scala-client/pull/299 - most recent fully-commented example
* https://github.com/guardian/play-secret-rotation/pull/416
* https://github.com/guardian/play-googleauth/pull/208

See also [_all repos_](https://github.com/search?q=%22guardian%2Fgha-scala-library-release-workflow%22++NOT+is%3Aarchived+NOT+repo%3Aguardian%2Fgha-scala-library-release-workflow&type=code) using Scala Library Release Workflow.
