#!/bin/bash

set -e 
set -u
set -o pipefail 
# set -x
# https://coderwall.com/p/fkfaqq/safer-bash-scripts-with-set-euxo-pipefail

zenroom                                                            /src/01-CITIZEN-credential-keygen.zencode              > keypair.keys
zenroom -k keypair.keys                                            /src/02-CITIZEN-credential-request.zencode             > blind_signature.req
zenroom                                                            /src/03-CREDENTIAL_ISSUER-keygen.zencode               > ci_keypair.keys
zenroom -k ci_keypair.keys                                         /src/04-CREDENTIAL_ISSUER-publish-verifier.zencode     > ci_verify_keypair.keys
zenroom -k ci_keypair.keys            -a blind_signature.req       /src/05-CREDENTIAL_ISSUER-credential-sign.zencode      > ci_signed_credential.json
zenroom -k keypair.keys               -a ci_signed_credential.json /src/06-CITIZEN-aggregate-credential-signature.zencode > credential.json
zenroom -k credential.json            -a ci_verify_keypair.keys    /src/07-CITIZEN-prove-credential.zencode               > blindproof_credential.json
zenroom -k blindproof_credential.json -a ci_verify_keypair.keys    /src/08-VERIFIER-verify-credential.zencode
zenroom -k credential.json            -a ci_verify_keypair.keys    /src/09-CITIZEN-create-petition.zencode                > alice_petition_request.json
zenroom -k ci_verify_keypair.keys     -a petition_request.json     /src/10-VERIFIER-approve-petition.zencode              > petition.json
zenroom -k credential.json            -a ci_verify_keypair.keys    /src/11-CITIZEN-sign-petition.zencode                 > petition_signature.json
zenroom -k petition.json              -a petition_signature.json   /src/12-LEDGER-add-signed-petition.zencode            > petition-increase.json
zenroom -k credential.json            -a petition-increase.json    /src/13-CITIZEN-tally-petition.zencode                > tally.json
zenroom -k tally.json                 -a petition-increase.json    /src/14-CITIZEN-count-petition.zencode              

exit $?
