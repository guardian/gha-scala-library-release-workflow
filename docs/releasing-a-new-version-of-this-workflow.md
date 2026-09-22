# Releasing a New Version of This Workflow

This guide is for releasing a new version of the gha-scala-library-release-workflow. (If you instead want to release a new version of another library *using* this workflow, see [making-a-release.md](./making-a-release.md).)

## Process

1. Choose a version number for your release using [Semantic Versioning](https://semver.org/)

   - The [releases page for this repository](https://github.com/guardian/gha-scala-library-release-workflow/releases) may be helpful for deciding on your new release version

2. [Draft a new release](https://github.com/guardian/gha-scala-library-release-workflow/releases/new) in the GitHub UI

   - Under `Select tag`, type in the new version number (`vX.Y.Z`) and click `Create new tag`
   - Manually select the previous tag (because auto will fail)
   - Click `Generate release notes`
   - Click `Publish Release`

3. Pull the latest tags

   ```sh
   git fetch --tags
   ```

4. Update the major version tag to point to the new minor version:

   ```sh
   git tag -f v2 v2.0.4 && git push -f origin v2
   ```

5. Confirm the major version tag points to the same commit as the new minor version tag

This video gives a detailed walkthrough of the release process:

https://github.com/user-attachments/assets/b503d13e-7318-4a58-a641-a0697fda4c87
