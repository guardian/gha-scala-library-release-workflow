# GHA Scala Library Release Workflow
_Publishing Scala libraries to Maven Central using GitHub Actions (GHA), keeping release credentials isolated securely from the library build_

The [`reusable-release.yml`](https://github.com/guardian/gha-scala-library-release-workflow/blob/main/.github/workflows/reusable-release.yml) workflow puts the stages of publishing your library to Maven Central
into separate workflow [jobs](https://docs.github.com/en/actions/using-jobs/using-jobs-in-a-workflow):

![image](https://github.com/guardian/gha-scala-library-release-workflow/assets/52038/3d229ccd-e60f-44f7-86e7-0e607134e47b)

This means your library's code, with its tests and dependencies, does **NOT** have access to your release credentials:

* [Sonatype OSSRH](https://central.sonatype.org/publish/publish-guide/) username & password
* [PGP signing key](https://central.sonatype.org/publish/requirements/gpg/)

So while the library's code is being compiled, its tests run, and artifacts created, there is no way for malicious code to
[exfiltrate](https://www.synacktiv.com/en/publications/cicd-secrets-extraction-tips-and-tricks) those secrets.

### Examples

* https://github.com/guardian/etag-caching/blob/main/.github/workflows/release.yml

