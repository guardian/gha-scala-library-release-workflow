# Supplying Credentials

Any repo that wants to use `gha-scala-library-release-workflow` needs to supply release credentials
to the workflow:

* [Sonatype OSSRH](https://central.sonatype.org/publish/publish-guide/) username & password
* [PGP signing key](https://central.sonatype.org/publish/requirements/gpg/) - used for signing artifacts, and
  the Git release tag.
* [GitHub App private key](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/managing-private-keys-for-github-apps) - used
  for jobs in the release workflow to authenticate & perform actions as the GitHub App with the GitHub API.

For any given organisation, a single set of credentials can be shared as GitHub
[Organization-level secrets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-an-organization)
(so that each individual developer doesn't need their _own_ set of credentials) - you just need to make sure your repo
has _access_ to those secrets.

### Guardian-specific access

**Guardian developers:** We use [`guardian/github-secret-access`](https://github.com/guardian/github-secret-access)
to grant repos access to the necessary Organisation secrets - you need to raise a PR (like [this example PR](https://github.com/guardian/github-secret-access/pull/24))
which will grant access to these:

* `AUTOMATED_MAVEN_RELEASE_SONATYPE_PASSWORD`
* `AUTOMATED_MAVEN_RELEASE_PGP_SECRET`
* `AUTOMATED_MAVEN_RELEASE_GITHUB_APP_PRIVATE_KEY`

### Generating new credentials

See the docs on [generating new credentials](generating-credentials.md) if your organisation is working with
`gha-scala-library-release-workflow` for the very first time, or if you need to rotate the shared credentials.