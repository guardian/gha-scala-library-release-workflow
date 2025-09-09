# Releasing a New Version of This Workflow

This guide is for releasing a new version of the gha-scala-library-release-workflow. (If you instead want to release a new version of another library *using* this workflow, see [making-a-release.md](./making-a-release.md).)

## Process

1. Choose a version number for your release using [Semantic Versioning](https://semver.org/)

  - The [releases page for this repository](https://github.com/guardian/gha-scala-library-release-workflow/releases) may be helpful for deciding on your new release version

2. Call [workflow-release.sh](../internal/workflow-release.sh) with your chosen version number. For example, if your chosen version number was 2.0.4, you would run:

  ```sh
  ./internal/workflow-release.sh 2.0.4
  ```

3. Push the tag the script has created:

  ```sh
  git push origin v2.0.4
  ```

4. Update the major version tag to point to the new minor version:

  ```sh
  git tag -f v2 v2.0.4 && git push -f origin v2
  ```

5. [Draft a new release](https://github.com/guardian/gha-scala-library-release-workflow/releases/new) in the github UI

  - select your new tag
  - manually select the previous tag (because auto will fail)
  - click Generate Release Notes
  - click Publish Release

6. Confirm the major version tag points to the same commit as the new minor version tag
