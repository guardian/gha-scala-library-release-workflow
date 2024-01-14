# Supplying Credentials

Any repo that wants to use `gha-scala-library-release-workflow` needs to supply release credentials
to the workflow:

* [Sonatype OSSRH](https://central.sonatype.org/publish/publish-guide/) username & password
* [PGP signing key](https://central.sonatype.org/publish/requirements/gpg/)

For any given organisation, a single set of credentials can be shared with GitHub
[Organization-level secrets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-an-organization)
(so that each individual developer doesn't need their _own_ set of credentials) - you just need to make sure your repo
has _access_ to those secrets.

### Guardian-specific access

**Guardian developers:** We use [`guardian/github-secret-access`](https://github.com/guardian/github-secret-access)
to grant repos access to the `AUTOMATED_MAVEN_RELEASE_PGP_SECRET` & `AUTOMATED_MAVEN_RELEASE_SONATYPE_PASSWORD`
secrets - you need to raise a PR there (like [this example PR](https://github.com/guardian/github-secret-access/pull/24))
to grant your repo access to the organisation-wide secrets.

### Generating new credentials

See the docs on [generating new credentials](generating-credentials.md) if your organisation is working with
`gha-scala-library-release-workflow` for the very first time, or if you need to rotate the shared credentials.