# Making a Release

Once a project has been [configured](configuration.md) to use `gha-scala-library-release-workflow`,
a release can be performed by any GitHub user with `write` access to the repo, simply by triggering
the release workflow.

Here's a video of that in action _(full-screen the video to see all details)_:

https://github.com/guardian/gha-scala-library-release-workflow/assets/52038/ec18f213-5d85-4eff-9742-2a158d79b04b

## Walkthrough of steps

* Click on the `Actions` tab in your repo:<br>
  ![image](https://github.com/guardian/gha-scala-library-release-workflow/assets/52038/37c851d8-20a8-44b6-a5f4-b3b7b1b3c4de)
* Select the `Release` workflow from the list of workflows on the left-hand side of the page:<br>
  ![image](https://github.com/guardian/gha-scala-library-release-workflow/assets/52038/a9ee9dd8-5443-41f6-b335-3b9ecf3e3b1d)
* Click on `Run workflow` on the right-hand side of the blue _"This workflow has a workflow_dispatch event trigger."_ bar:<br>
  ![image](https://github.com/guardian/gha-scala-library-release-workflow/assets/52038/4f25745a-207d-4d40-b697-d488918930f0)
* In the modal popup that appears:
  * For a normal full release on the main branch, leave the branch set to the default (ie `main`). If you're
    making a 'preview' release of an unmerged PR, select the PR's branch from the `Branch:` dropdown.
  * Click on the green `Run workflow` button:<br>
  ![image](https://github.com/guardian/gha-scala-library-release-workflow/assets/52038/b8669ae3-bb39-4ca6-b285-4eef3d3e341b)
* You've started a release! However, the GitHub UI can be slow to update, so **reload** the page, and then click on
  the new workflow run to see its progress:<br>
  ![image](https://github.com/guardian/gha-scala-library-release-workflow/assets/52038/c9a20b42-9b5b-4161-82d0-0e1d6f2c9768)


### Why can't releases be triggered in another way?

One potentially elegant alternative way to trigger a release would be trigger the workflow when a
[GitHub Release](https://docs.github.com/en/repositories/releasing-projects-on-github/managing-releases-in-a-repository)
is manually created by a developer.

Unfortunately that would require a Git release version tag to be previously created by the developer, and a
primary motivation of `gha-scala-library-release-workflow` is to avoid humans choosing release version numbers - because
humans are terrible at judging compatibility, and thus knowing what the correct
[semver version bump](https://www.scala-lang.org/blog/2021/02/16/preventing-version-conflicts-with-versionscheme.html#early-semver-and-sbt-version-policy)
should be.

If a human has manually chosen a version number before automated workflow occurs, we've already lost. Better to let the
workflow make automatic compatibility-based checks, and derive the new version number (and release tag) for itself.

The `gha-scala-library-release-workflow` automatically creates a GitHub Release, with automatically-generated release
notes, as part of the release process, so a GitHub Release is still created with each release.
