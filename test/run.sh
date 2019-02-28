#!/bin/bash

set -e 
set -u
set -o pipefail 
# set -x
# https://coderwall.com/p/fkfaqq/safer-bash-scripts-with-set-euxo-pipefail

/code/zenroom/src/zenroom-static  01-CITIZEN-credential-keygen.zencode > keypair.keys  2>/dev/null
/code/zenroom/src/zenroom-static  -k keypair.keys 02-CITIZEN-credential-request.zencode > blind_signature.req  2>/dev/null
/code/zenroom/src/zenroom-static  03-CREDENTIAL_ISSUER-keygen.zencode > ci_keypair.keys  2>/dev/null
/code/zenroom/src/zenroom-static  -k ci_keypair.keys 04-CREDENTIAL_ISSUER-publish-verifier.zencode > ci_verify_keypair.keys  2>/dev/null
/code/zenroom/src/zenroom-static  -k ci_keypair.keys -a blind_signature.req 05-CREDENTIAL_ISSUER-credential-sign.zencode > ci_signed_credential.json  2>/dev/null
/code/zenroom/src/zenroom-static  -k keypair.keys -a ci_signed_credential.json 06-CITIZEN-aggregate-credential-signature.zencode > credential.json  2>/dev/null
/code/zenroom/src/zenroom-static  -k credential.json -a ci_verify_keypair.keys 07-CITIZEN-prove-credential.zencode > blindproof_credential.json  2>/dev/null
/code/zenroom/src/zenroom-static  -a ci_verify_keypair.keys -k blindproof_credential.json 08-VERIFIER-verify-credential.zencode  2>/dev/null



exit $?
