# New PGP keys

**Guardian developers:** [further docs here](https://docs.google.com/document/d/1zA8CHa1a8faemorWokUlbkdexYzpilalqcPFwkRu92M/edit?tab=t.0#heading=h.mnrh0k50nysb).

There are 4 steps to performing a credential rotation on the PGP key used by `gha-scala-library-release-workflow`:

## Generate new PGP keypair

The keypair should have a [**passphrase-less** private key](https://unix.stackexchange.com/a/550538/46453) -
if you're generating the keypair, you can just enter blank passphrases.

```bash
gpg --quick-generate-key "Example Automated Maven Release <automated.maven@example.com>"
```

This will give a new key id, eg like `EF53C0E05A7067985C09F1B2AAE7330D94C67345`.

## Publish Public PGP key

Maven Central _requires_ that the public PGP key is published to public keyservers - it will
[_reject_](https://github.com/guardian/redirect-resolver/actions/runs/12158544330/job/33906914072#step:5:63)
artifacts that are signed with unknown PGP keys:

> Failed: signature-staging, failureMessage:No public key: Key with id: (aae7330d94c67345) was not able to be located on <a href="http://pgp.mit.edu:11371/">http://pgp.mit.edu:11371/</a>. Upload your public key and try the operation again.

The [official instructions](https://central.sonatype.org/publish/requirements/gpg/#distributing-your-public-key)
say to use `gpg --keyserver` to publish the key, but unfortunately this gives
`gpg: keyserver send failed: Network is unreachable` errors - so instead we have to
manually paste our key into a web form on a PGP keyserver website.

Execute this command to get the new public key copied into your copy-n-paste:

```bash
gpg --armor --export [insert key fingerprint here] | pbcopy
```

_N.B. The above command uses `--export`, not `--export-secret-key` - we do **not** want
to publicly share our private key._

You can use either (or both) of these keyservers:

* https://keyserver.ubuntu.com/#submitKey - this _feels_ kind of more stable, and search works
* https://pgp.mit.edu/ - Maven Central seems to be checking keys with this keyserver

PGP keyservers are supposed to synchronise with each other, so wherever you publish the
key it should eventually make it to the keyserver that Maven Central is checking with - but
for the time being, publishing to `pgp.mit.edu` may get the key available sooner.

## Store Private PGP key in a GitHub secret

Execute this command to get the private key copied into your copy-n-paste:

```
gpg --armor --export-secret-key [insert key fingerprint here] | pbcopy
```

This can then be pasted into a GitHub secret.

**Guardian developers:** We use the organisation-level GitHub secret
[`AUTOMATED_MAVEN_RELEASE_PGP_SECRET`](https://github.com/organizations/guardian/settings/secrets/actions/AUTOMATED_MAVEN_RELEASE_PGP_SECRET) -
as it's organisation-level, only an owner of our GitHub organisation can access it.

## Destroy or secure your local copy of the PGP key

As the private key had to be made **passphrase-less**, it is now vulnerable, and
should be deleted or [edited](https://stackoverflow.com/q/77716552/438886) to add a passphrase.
