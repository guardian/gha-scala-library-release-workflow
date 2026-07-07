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

## Can you ignore linting errors?

If the linting check finds a branch mismatch, you can use your judgement as to whether
it's worth making the corresponding change to `reusable-release.yml` to satisfy the
lint check. A key point is whether you're planning to actually do
[a manual test release run of the PR](https://github.com/guardian/etag-caching/pull/124/changes)
before merging - if you are, you _do_ want to fix the errors, so that your new code actually
_is_ executed in your test run. If you don't intend to do a test run, then the
linter is warning you about something that won't affect you - and you can ignore it.

* If you're working on a PR that substantively changes the implementation of the
  GitHub Actions under `actions/`, then you probably _do_ want to correct the refs
  in `reusable-release.yml` to point to your branch, so that your test runs actually
  _do_ execute your updated code.
* Low-risk dependabot updates probably won't warrant making a test run, so don't justify 
  making the manual ref changes to make the linter pass.

## Refs must be set back to `main` before merging

Note that if you _do_ change the refs while trying out your PR, you'll need to revert
that ref-change (go back to using `@main`) before the branch is merged.

## Doesn't making a release mean changing the refs too?

Yes! See [Releasing a new version of this workflow](releasing-a-new-version-of-this-workflow.md).
