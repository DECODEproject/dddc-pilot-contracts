#!/bin/bash

set -e 
set -u
set -o pipefail 
# set -x
# https://coderwall.com/p/fkfaqq/safer-bash-scripts-with-set-euxo-pipefail

/code/zenroom/src/zenroom-static /src/01-CITIZEN-request-keypair.zencode > keypair.keys 2>/dev/null
/code/zenroom/src/zenroom-static -k keypair.keys /src/02-CITIZEN-request-blind-signature.zencode > blind_signature.req  2>/dev/null
/code/zenroom/src/zenroom-static /src/03-CREDENTIAL_ISSUER-keypair.zencode > ci_keypair.keys  2>/dev/null
/code/zenroom/src/zenroom-static -k ci_keypair.keys /src/04-CREDENTIAL_ISSUER-public-verify-keypair.zencode > ci_verify_keypair.keys  2>/dev/null
/code/zenroom/src/zenroom-static -k ci_keypair.keys -a blind_signature.req /src/05-CREDENTIAL_ISSUER-credential-blind-signature.zencode > ci_signed_credential.json  2>/dev/null
/code/zenroom/src/zenroom-static -k keypair.keys -a ci_signed_credential.json /src/06-CITIZEN-credential-blind-signature.zencode > credential.json  2>/dev/null
/code/zenroom/src/zenroom-static -k ci_verify_keypair.keys -a credential.json /src/07-CITIZEN-blind-proof-credential.zencode > blindproof_credential.json  2>/dev/null
/code/zenroom/src/zenroom-static -k ci_verify_keypair.keys -a blindproof_credential.json /src/08-VERIFIER-verify-blind-proof-credential.zencode  2>/dev/null
