# Configuration

Start here if you're setting up a repo use `gha-scala-library-release-workflow`! If your organisation has never used
`gha-scala-library-release-workflow` before, you'll need to follow the instructions in
[Organisation Setup](org-setup.md) first.

The release workflow needs a `release.yml` GitHub workflow in your repo, and specific updated `sbt` settings.

[Example GitHub pull requests](#examples) making these changes can be found further below.

## Repo settings

* Ensure [your GitHub App](github-app.md) has access to your repo. **Guardian developers:** click
  `Configure` on the [gu-scala-library-release](https://github.com/apps/gu-scala-library-release) app -
  so long as you have admin permissions on your repo, you should be able to add your repo to the list
  of selected repositories.
* **Guardian developers:** Comply with the repository requirements of [`guardian/github-secret-access`](https://github.com/guardian/github-secret-access?tab=readme-ov-file#how-does-it-work),
  i.e. ensure the repository has a `production` Topic label.

### Branch protection

Your [GitHub App](github-app.md) will need to push to directly to your default branch as part of the
release, bypassing any branch protection. GitHub provides two different methods of branch protection:
* [Branch protection **rules**](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches) -
  there is no mechanism to allow a GitHub App to bypass branch protection **rules**, so you'll
  need to **remove any rules that apply to the default branch**.
* [Branch protection **rulesets**](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-rulesets/about-rulesets) -
  rulesets _can_ be configured to allow specified GitHub Apps (e.g. _your_ GitHub app) to bypass branch protection -
  update your rulesets accordingly. **Guardian developers:** see [recommended branch protection rulesets](https://github.com/guardian/recommendations/blob/main/github-rulesets.md).
  
## GitHub workflow

[Example `.github/workflows/release.yml`](https://github.com/guardian/etag-caching/blob/main/.github/workflows/release.yml)

The functionality of `gha-scala-library-release-workflow` is provided in a
[reusable workflow](https://docs.github.com/en/actions/using-workflows/reusing-workflows)
called [`reusable-release.yml`](https://github.com/guardian/gha-scala-library-release-workflow/blob/main/.github/workflows/reusable-release.yml) -
don't copy-and-paste that big file, instead just make a small `release.yml` workflow to
[_call_](https://docs.github.com/en/actions/using-workflows/reusing-workflows#calling-a-reusable-workflow)
it (as in the example file above).

Your repo will require access to [release credentials](credentials/supplying-credentials.md) to
[pass on those secrets](https://github.com/guardian/etag-caching/blob/main/.github/workflows/release.yml#L10-L13)
to the workflow.

## Java version

[Example `.tool-versions`](https://github.com/guardian/etag-caching/blob/main/.tool-versions)

Your repository *must* contain an [`asdf`](https://asdf-vm.com/)-formatted `.tool-versions` file
in the root of the repository, specifying the Java version to be used by the workflow for
building your project, eg:

```
java corretto-21.0.3.9.1
```

Note that although `asdf` requires a fully-specified Java version (eg `21.0.3.9.1` - use
`asdf list-all java` to list all possible Java versions), currently the workflow will only
match the *major* version of Java specified in the file (eg `21`), and will _always_ use the
AWS Corretto distribution of Java. This is due to
[limitations](https://github.com/actions/setup-java/issues/615) in
[`actions/setup-java`](https://github.com/actions/setup-java).

As recommended [below](#recommended-sbt-settings), you should also specify a `-release` flag in
`scalacOptions` to ensure that your library is compiled for any older versions of Java you wish
to support, even if you're taking advantage of a more recent version of Java for _building_ the
library.

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
* **Artifact-producing modules** - any module (project or subproject) that creates an artifact for Maven Central
  * `organization` - this dictates the [groupId](https://maven.apache.org/guides/mini/guide-naming-conventions.html) of
    your artifacts, and can be either the same as your Sonatype account profile name (eg `com.gu` for the Guardian),
    or a dot-suffixed version of it (eg `com.gu.foobar`) if your project ('foobar') releases multiple artifacts
    [_(details)_](https://github.com/guardian/gha-scala-library-release-workflow/pull/15)
  * `licenses := Seq(License.Apache2)` - or whatever license you're using. Specifying a license is
    [*required*](https://central.sonatype.org/publish/requirements/#license-information) for submitting artifacts
    to Maven Central.
  * `scalacOptions` should include `-release:11` (available with Scala [2.13.9](https://www.scala-lang.org/news/2.13.9)
    and above, also known as `-java-output-version`
    [in Scala 3](https://www.scala-lang.org/blog/2022/04/12/scala-3.1.2-released.html#changes-to-other-compatibility-flags)), or whatever minimum version of Java you want to support.
    The workflow will _build_ your project with whatever Java version you declare in [`.tool-versions`](#java-version) -
    but while this can be a relatively new version of Java, in order for your compiled code to support
    _older_ versions of Java, and avoid `UnsupportedClassVersionError` errors, you'll
    need to set this flag. See also [Scala/Java compatibility](https://docs.scala-lang.org/overviews/jdk-compatibility/overview.html).
* **Non-artifact-producing modules** - any module that _doesn't_ make an artifact to publish to Maven Central
  (often, the 'root' project in a multi-project build)
  * `publish / skip := true` (rather than other legacy hacks like `publishArtifact := false`). This setting is
     respected by `sbt-version-policy` - it won't attempt to calculate compatibility on a module that doesn't
    publish artifacts.
* **Top-level 'release' module** - if your project has a [multi-module](https://www.scala-sbt.org/1.x/docs/Multi-Project.html)
  build this could be called 'root', or, if your project only has one module, it and your
  artifact-producing module could be the same thing, and just use top-level settings.
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

You can see a long list of example PRs updating repos to use `gha-scala-library-release-workflow`
[here](https://github.com/guardian/gha-scala-library-release-workflow/issues/20).

See also [_all repos_](https://github.com/search?q=%22guardian%2Fgha-scala-library-release-workflow%22++NOT+is%3Aarchived+NOT+repo%3Aguardian%2Fgha-scala-library-release-workflow+language%3AYAML&type=code&l=YAML) using Scala Library Release Workflow.

