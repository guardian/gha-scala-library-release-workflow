# Security Design

The [`reusable-release.yml`](https://github.com/guardian/gha-scala-library-release-workflow/blob/main/.github/workflows/reusable-release.yml) workflow puts the stages of publishing your library to Maven Central
into separate workflow [jobs](https://docs.github.com/en/actions/using-jobs/using-jobs-in-a-workflow):

![image](https://github.com/guardian/gha-scala-library-release-workflow/assets/52038/3d229ccd-e60f-44f7-86e7-0e607134e47b)

The individual workflow jobs can be distinguished in their level of trust - what code they execute:

* 🎊 Library build/test code - the potentially dangerous code coming from the library's transitive dependencies is represented by the _shiny & unknown wonders_ falling out of the confetti ball 
* 🔒 Fixed code that's dictated by `gha-scala-library-release-workflow` - trusted with release credentials and write access on the repository

This means your library's code, with its tests and dependencies, does **NOT** have access to your release credentials:

* [Sonatype OSSRH](https://central.sonatype.org/publish/publish-guide/) username & password
* [PGP signing key](https://central.sonatype.org/publish/requirements/gpg/)

So while the library's code is being compiled, its tests run, and artifacts created, there is no way for malicious code to
[exfiltrate](https://www.synacktiv.com/en/publications/cicd-secrets-extraction-tips-and-tricks) those secrets.
