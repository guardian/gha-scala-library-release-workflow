# GHA Scala Library Release Workflow
_Publishing Scala libraries to Maven Central using GitHub Actions (GHA), keeping release credentials isolated securely from the library build_

![image](https://github.com/guardian/gha-scala-library-release-workflow/assets/52038/3d229ccd-e60f-44f7-86e7-0e607134e47b)

This workflow is ideal if your organisation has lots of developers who want an easy, secure, low-config way
to publish releases of Scala libraries!

See the docs for information on:

* [**Configuration**](docs/configuration.md) - Start here to set up a repo use `gha-scala-library-release-workflow`!
* [**Credentials**](docs/credentials.md) - how to access shared credentials, and generate new credentials if necessary
* [**Making a Release**](docs/making-a-release.md) - how to trigger the workflow to publish a new release
* [**Security Design**](docs/security-design.md) - how the workflow keeps your release
  credentials isolated from potentially dangerous code in your library's dependencies

https://github.com/guardian/gha-scala-library-release-workflow/assets/52038/ec18f213-5d85-4eff-9742-2a158d79b04b
