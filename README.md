# GHA Scala Library Release Workflow
_Publishing Scala libraries to Maven Central using GitHub Actions (and keeping publication credentials away from the library build)_

This [Reusable Workflow](https://docs.github.com/en/actions/using-workflows/reusing-workflows) puts the stages of publishing into separate workflow
[Jobs](https://docs.github.com/en/actions/using-jobs/using-jobs-in-a-workflow) - this means that all the credentials required for publication
(PGP signing key & Sonatype [OSSRH](https://central.sonatype.org/publish/publish-guide/) username/password) are _not_ available to the code
running the library build - so when the library's code is being compiled, and the tests run, there is no way for malicious code to exfiltrate those
secrets.


### Examples

https://github.com/guardian/etag-caching/blob/main/.github/workflows/release.yml

