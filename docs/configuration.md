# Configuration

Start here if you're setting up a repo use `gha-scala-library-release-workflow`! If your organisation has never used
`gha-scala-library-release-workflow` before, you'll need to follow the instructions in
[Organisation Setup](org-setup.md) first.

The release workflow needs a `release.yml` GitHub workflow in your repo, and specific updated `sbt` settings.

[Example GitHub pull requests](#examples) making these changes can be found further below.

## Repo settings

* Disable [branch protection **rules**](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches)
  on any branch the workflow will be pushing to (ie the default branch). Note that PR #26 means that you can use branch protection rulesets to protect your default branch, so long as you allow your GitHub App to bypass those restrictions.
### Guardian developers 
* Set the custom property `production_status` to `production` to apply  branch protection to the default branch via a ruleset (this allows the Scala release app to bypass branch protection).
* Create a separate 'Status checks' ruleset in your repo with the Branch protection property 'Require status checks to pass' -> 'Require branches to be up to date before merging' and add your repo's status check(s) to the 'Status checks that are required' list. For example, if your repo has a CI workflow with the name 'CI', then the setting would look like this:
![status_checks.png](status_checks.png)
* Also add the Scala release app to the ruleset bypass list as in the branch protection ruleset.
* Comply with the repository requirements of
  [`guardian/github-secret-access`](https://github.com/guardian/github-secret-access?tab=readme-ov-file#how-does-it-work),
  i.e. ensure the repository has a `production` topic label.

## GitHub workflow

[Example `.github/workflows/release.yml`](https://github.com/guardian/etag-caching/blob/main/.github/workflows/release.yml)

The functionality of `gha-scala-library-release-workflow` is provided in a
[reusable workflow](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
called [`reusable-release.yml`](https://github.com/guardian/gha-scala-library-release-workflow/blob/main/.github/workflows/reusable-release.yml) -
don't copy-and-paste that big file, instead just make a small `release.yml` workflow to
[_call_](https://docs.github.com/en/actions/using-workflows/reusing-workflows#calling-a-reusable-workflow)
it (as in the example file above).

Your repo will require access to [release credentials](credentials/supplying-credentials.md) to
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

[Example `version.sbt`](https://github.com/guardian/etag-caching/blob/main/version.sbt)

* `version` - as [specified by `sbt-release`](https://github.com/sbt/sbt-release?tab=readme-ov-file#versionsbt), this
  should be the sole entry in your `version.sbt` file, and should define a **semver** version (`major.minor.patch`),
  which during normal dev has a `-SNAPSHOT` suffix (eg `1.4.7-SNAPSHOT`). You can think of `-SNAPSHOT` as meaning
  'a snapshot preview' - so when you're working on `1.4.7-SNAPSHOT`, you're working on a _preview_ of the forthcoming
  `1.4.7` release. The workflow will automatically update the `version` during each release, as appropriate.

[Example `build.sbt`](https://github.com/guardian/etag-caching/blob/main/build.sbt)
* Artifact-producing modules
  * `organization` - this dictates the [groupId](https://maven.apache.org/guides/mini/guide-naming-conventions.html) of
    your artifacts, and can be either the same as your Sonatype account profile name (eg `com.gu` for the Guardian),
    or a dot-suffixed version of it (eg `com.gu.foobar`) if your project ('foobar') releases multiple artifacts
    [_(details)_](https://github.com/guardian/gha-scala-library-release-workflow/pull/15)
  * `licenses := Seq(License.Apache2)` - or whatever license you're using. Specifying a license is
    [*required*](https://central.sonatype.org/publish/requirements/#license-information) for submitting artifacts
    to Maven Central.
  * `scalacOptions` should include `-release:11` (available with Scala [2.13.9](https://www.scala-lang.org/news/2.13.9)
    and above, also known as `-java-output-version`
    [in Scala 3](https://www.scala-lang.org/blog/2022/04/12/scala-3.1.2-released.html#changes-to-other-compatibility-flags)) -
    the workflow will always use one of the most recent LTS releases of Java
    [supported by Scala](https://docs.scala-lang.org/overviews/jdk-compatibility/overview.html),
    but the generated class files will be compatible with whichever version of Java you target.
* Top-level 'release' module - if your project has a [multi-module](https://www.scala-sbt.org/1.x/docs/Multi-Project.html)
  build this could be called 'root', or, if your project only has one module, it and your
  artifact-producing module could be the same thing, and just use top-level settings.
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
  * `releaseVersion := ReleaseVersion.fromAggregatedAssessedCompatibilityWithLatestRelease().value` - to activate the
      automatic compatibility-based version-numbering provided by the `sbt-version-policy` plugin. This means your `version`
      can go up by more than just an `x.x.PATCH` increment in a release, if
      [Scala semver rules](https://www.scala-lang.org/blog/2021/02/16/preventing-version-conflicts-with-versionscheme.html#early-semver-and-sbt-version-policy)
      say that it should. You'll need `import sbtversionpolicy.withsbtrelease.ReleaseVersion` at the top of your  `build.sbt`
      to access this method.

### Unnecessary `sbt` plugins

* [`sbt-pgp`](https://github.com/sbt/sbt-pgp) - the workflow [`🔒 Sign`](https://github.com/guardian/gha-scala-library-release-workflow/blob/7d278d4d44e30b4b4c0f6791053bdeb40b8159cb/.github/workflows/reusable-release.yml#L183C11-L206)
  job now handles PGP signing directly with GPG

### Unnecessary `sbt` settings

These settings are now set by `gha-scala-library-release-workflow` and can be removed from your `build.sbt`
or `sonatype.sbt` (`sonatype.sbt` can generally be deleted entirely):

* `homepage`
* `developers`
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

