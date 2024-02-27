# Generating new credentials

Normally you'll be using [shared organisation-wide credentials](supplying-credentials.md),
but if you need to rotate those credentials, or just create some new ones for your organisation:

## Updating a Sonatype OSSRH user's password

See [Sonatype's instructions](https://central.sonatype.org/faq/ossrh-password/).

## Generating a new PGP key

See [Sonatype's instructions](https://central.sonatype.org/publish/requirements/gpg/#generating-a-key-pair) for
generating a keypair - ensure you upload the public key to a [keyserver](https://keyserver.ubuntu.com/).

However, note that `gha-scala-library-release-workflow` requires a
[**passphrase-less** private key](https://unix.stackexchange.com/a/550538/46453), and that key
should be plaintext, not BASE64-encoded.

```shell
gpg --armor --export-secret-key [insert key fingerprint here] | pbcopy
```

## Generating a new GitHub App private key

See [GitHub's instructions](https://docs.github.com/en/apps/creating-github-apps/authenticating-with-a-github-app/managing-private-keys-for-github-apps#generating-private-keys) for generating a private key. If you haven't already created a GitHub App for the
release workflow, see [Setting up the GitHub App](github-app.md) first.

**Guardian developers:** Here's a direct link to our GitHub App settings page, where you can generate a new private key:
https://github.com/organizations/guardian/settings/apps/gu-scala-library-release