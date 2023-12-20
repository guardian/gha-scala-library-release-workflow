# Credentials

Making a release to Sonatype OSSRH (the staging repository for publishing to Maven Central)
requires two sets of credentials:

* [Sonatype OSSRH](https://central.sonatype.org/publish/publish-guide/) username & password
* [PGP signing key](https://central.sonatype.org/publish/requirements/gpg/)

## Shared credentials

If you have more than one developer working on a library, and you want to use an automated
release process like `gha-scala-library-release-workflow`, you probably _don't_ want each
developer to have their own set of release credentials (especially as the organisation onboarding & offboarding
process for Sonatype credentials is quite manual).

Instead, organisation-wide credentials can be used, and these can be distributed as
[Organization-level secrets](https://docs.github.com/en/actions/security-guides/using-secrets-in-github-actions#creating-secrets-for-an-organization)
with Repository access set to only selected repositories.

### Guardian-specific access

**Guardian developers:** See [`guardian/github-secret-access`](https://github.com/guardian/github-secret-access) and this
[example PR](https://github.com/guardian/github-secret-access/pull/24) granting a new
repo access to the organisation-wide secrets.

## Generating new credentials

Normally you'll be using the shared organisation-wide credentials, but if you need to rotate those credentials,
or just create some new ones for your organisation:

### Generating a new PGP key

See [Sonatype's instructions](https://github.com/guardian/github-secret-access/pull/24) for generating
a keypair - ensure you upload the public key to a [keyserver](https://keyserver.ubuntu.com/).

However, note that `gha-scala-library-release-workflow` requires a
[**passphrase-less** private key](https://unix.stackexchange.com/a/550538/46453), and that key
should be plaintext, not BASE64-encoded.

### Updating a Sonatype OSSRH user's password

See [Sonatype's instructions](https://central.sonatype.org/faq/ossrh-password/).
