# Configuration

Configuring a repo to use `gha-scala-library-release-workflow` requires a `release.yml` GitHub workflow in your repo,
and updated `sbt` settings.

[Example GitHub pull requests](#examples) making these changes can be found further below.

## GitHub workflow

[Example `.github/workflows/release.yml`](https://github.com/guardian/etag-caching/blob/main/.github/workflows/release.yml)

The functionality of `gha-scala-library-release-workflow` is provided in a
[reusable workflow](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
called [`reusable-release.yml`](https://github.com/guardian/gha-scala-library-release-workflow/blob/main/.github/workflows/reusable-release.yml) -
don't copy-and-paste that big file, instead just make a small `release.yml` workflow to
[_call_](https://docs.github.com/en/actions/using-workflows/reusing-workflows#calling-a-reusable-workflow)
it (as in the example file above).

Your repo will require access to [release credentials](credentials.md) to
[pass on those secrets](https://github.com/guardian/etag-caching/blob/9935da29e76b8b89759bcfe967cc7c1c02aa1814/.github/workflows/release.yml#L11-L13)
to the workflow.

## `sbt`

### Recommended `sbt` plugins

[Example `project/plugins.sbt`](https://github.com/guardian/etag-caching/blob/main/project/plugins.sbt)

* [`sbt-version-policy`](https://github.com/scalacenter/sbt-version-policy) - to supply automatic compatibility-based
  version-numbering that follows [recommended Scala semver rules](https://www.scala-lang.org/blog/2021/02/16/preventing-version-conflicts-with-versionscheme.html#early-semver-and-sbt-version-policy)
  on your library, as well as automatically setting the [`versionScheme`](https://www.scala-sbt.org/1.x/docs/Publishing.html#Version+scheme)
  of your project to `"early-semver"` (essential).
* [`sbt-release`](https://github.com/sbt/sbt-release)
* [`sbt-sonatype`](https://github.com/xerial/sbt-sonatype) - you currently need to have this in your project's
  `plugins.sbt`, as the [`🎊 Create artifacts`](https://github.com/guardian/gha-scala-library-release-workflow/blob/7d278d4d44e30b4b4c0f6791053bdeb40b8159cb/.github/workflows/reusable-release.yml#L141-L158)
  job expects it, but in the future, the workflow will probably supply this automatically.

### Recommended `sbt` settings

[Example `build.sbt`](https://github.com/guardian/etag-caching/blob/main/build.sbt)

* `scalacOptions` should include `-release:11` (also known as `-java-output-version`
  [in Scala 3](https://www.scala-lang.org/blog/2022/04/12/scala-3.1.2-released.html#changes-to-other-compatibility-flags)) -
  the workflow will always compile with one of the most recent LTS releases of Java [supported by Scala](https://docs.scala-lang.org/overviews/jdk-compatibility/overview.html),
  but the generated class files will be compatible with whichever version of Java you target.
* `releaseVersion := fromAggregatedAssessedCompatibilityWithLatestRelease().value` - to activate the
  automatic compatibility-based version-numbering provided by the `sbt-version-policy` plugin.
* `publish / skip := true` (rather than other legacy hacks like `publishArtifact := false`) for
  sbt modules that don't generate artifacts (often, the 'root' project in a multi-project build). This
  setting is respected by `sbt-version-policy` - it won't attempt to calculate compatibility on a module
  that doesn't publish artifacts.
* In `releaseProcess`, you'll want _fewer_ steps than
  [the old list specified by `sbt-sonatype`](https://github.com/xerial/sbt-sonatype?tab=readme-ov-file#using-with-sbt-release-plugin),
  now just:
  `checkSnapshotDependencies, inquireVersions, runClean, runTest, setReleaseVersion, commitReleaseVersion, tagRelease, setNextVersion, commitNextVersion`
  _([if your tests require special privileges](https://github.com/guardian/facia-scala-client/pull/299/files#r1425649126)
  you may need to drop `runTest`)_

### Unnecessary `sbt` plugins

* [`sbt-pgp`](https://github.com/sbt/sbt-pgp) - the workflow [`🔒 Sign`](https://github.com/guardian/gha-scala-library-release-workflow/blob/7d278d4d44e30b4b4c0f6791053bdeb40b8159cb/.github/workflows/reusable-release.yml#L183C11-L206)
  job now handles PGP signing directly with GPG

### Unnecessary `sbt` settings

These settings are now set by `gha-scala-library-release-workflow` and can be removed from your `build.sbt`
or `sonatype.sbt` (`sonatype.sbt` can generally be deleted entirely):

* `homepage`
* `pomExtra`
* `publishTo`
* `sonatypeProfileName`
* `scmInfo`
* In `releaseProcess`, it's **essential** you remove steps that are now separately performed elsewhere in the workflow
  (ie _sign, release, push_):
    * `releaseStepCommand`s like  `publishSigned` and `sonatypeBundleRelease`
    * `pushChanges`


## Examples

GitHub pull requests on repos updating for  `gha-scala-library-release-workflow`:

* https://github.com/guardian/facia-scala-client/pull/299 _(most recent fully-commented example)_
* https://github.com/guardian/play-secret-rotation/pull/416
* https://github.com/guardian/play-googleauth/pull/208

See also [_all repos_](https://github.com/search?q=%22guardian%2Fgha-scala-library-release-workflow%22++NOT+is%3Aarchived+NOT+repo%3Aguardian%2Fgha-scala-library-release-workflow+language%3AYAML&type=code&l=YAML) using Scala Library Release Workflow.

