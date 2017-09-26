#!/bin/bash

# Initialise git-secret, generate a GPG encryption key, configure git-secret,
# decrypt all known secrets, and execute a command.

cat <<EOF
# `whoami`@`hostname`:$PWD$ setup-git-secret.sh $@
EOF

set -e

cd "$ICEKIT_PROJECT_DIR"

# Derive a fictitious email address for the encryption key.
export GPG_EMAIL="${GPG_EMAIL:-git-secret@$ICEKIT_PROJECT_NAME.icekit.interaction.net.au}"

# Generate a strong random passphrase.
export GPG_PASSPHRASE="${GPG_PASSPHRASE:-$(openssl rand -base64 48)}"

if [[ -d .git && ! -d .gitsecret ]]; then
	# Initialise git-secret.
	git secret init >/dev/null

	# Generate an encryption key for unattended decryption.
	gpg2 --batch --gen-key <<-EOF 2>/dev/null
		Key-Type: RSA
		Key-Usage: encrypt
		Passphrase: $GPG_PASSPHRASE
		Name-Email: $GPG_EMAIL
		EOF
	cat <<EOF
###############################################################################
# An encryption key has been generated for git-secret, with a random passphrase
# that will only be displayed one time, below:
#
#     $GPG_PASSPHRASE
#
# Make sure you add this passphrase to your password manager. You will need it
# to decrypt secrets in production environments.
#
# Quick start:
#
#     $ git secret add file  # Add 'file' as a secret to be encrypted
#     $ git secret hide      # Encrypt all secrets
#     $ git secret reveal    # Decrypt all secrets
#
# It is recommended to add 'git secret hide' to your pre-commit hook, so you
# won't miss any changes.
#
# For more information, see: http://sobolevn.github.io/git-secret/
#
# Troubleshooting on Mac OS
# -------------------------
# If 'git secret reveal' seems to do nothing for you on Mac OS and does not
# give any feedback at all, try running the following in your terminal to
# un-break the password prompt mechanism:
#
#     $ export GPG_TTY=\$(tty)
#
###############################################################################
EOF

	# Configure git-secret.
	git secret tell "$GPG_EMAIL" >/dev/null

	# Add to index, ready to commit.
	git add .gitsecret
	git add .gnupg
fi

# List and decrypt all known secrets.
SECRETS="$(git secret list 2>/dev/null || true)"  # Don't exit if there are no secrets
if [[ -n "$SECRETS" ]]; then
	cat <<-EOF
		Secrets:
		$SECRETS
		Decrypting...
		EOF
	git secret reveal -p "$GPG_PASSPHRASE"
fi

# Execute command.
exec "$@"
