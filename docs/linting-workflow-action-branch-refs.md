# Linting Workflow Action branch-refs

The main `reusable-release.yml` workflow makes many calls to internal GitHub Actions
defined in this same repo, eg:

```yaml
uses: guardian/gha-scala-library-release-workflow/actions/versioning@main
```

The `@main` at the end of that line is the ['branch-ref'](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax#example-using-a-public-action-in-a-subdirectory),
that tells us which git commit is the version of the `action.yml` that we want to use.

Note that, for any PR on this repo, if any of the internal Actions are modified -
eg `actions/versioning/action.yml` is modified - then unless the ref for that
action in `reusable-release.yml` is updated as well, running the workflow on that
branch will _not_ be running the same `action.yml` as contained in that PR.

We have a linting check, introduced in https://github.com/guardian/gha-scala-library-release-workflow/pull/73,
that warns if there are mismatched workflow action branch-refs.

If the linting check finds a branch mismatch, you can use your judgement as to whether
it's worth making the corresponding change to `reusable-release.yml`. Note that the 
change will need to be reverted before the branch is merged, and unless you're planning
to _run_ the code on the PR branch (ie make a test release), you won't get any benefit
from temporarily updating the branch-refs.

Low risk dependabot updates probably don't warrant making a manual change to make the
linter pass.

## Doesn't making a release mean changing the refs too?

Yes! See [Releasing a new version of this workflow](releasing-a-new-version-of-this-workflow.md).
