
<table style="border-collapse: collapse;">
		<tr>
			<td valign="center">
				    <a href="https://zenroom.dyne.org">
        <img src="https://cdn.jsdelivr.net/gh/DECODEproject/zenroom@master/docs/logo/zenroom.svg" height="140" alt="Zenroom">
    </a>
			</td>
						<td valign="center">
							 <img src="https://raw.githubusercontent.com/AjuntamentdeBarcelona/decidimbcn/master/app/assets/images/decidim-logo.png" height="100" valign="middle" alt="Decidim">
</td>
		</tr>
	</table>

<p>
	<a href="https://travis-ci.com/DECODEproject/dddc-pilot-contracts">
		<img src="https://travis-ci.com/DECODEproject/dddc-pilot-contracts.svg?branch=master" alt="Build Status">
	</a>
	<a href="https://dyne.org">
		<img src="https://img.shields.io/badge/%3C%2F%3E%20with%20%E2%9D%A4%20by-Dyne.org-blue.svg" alt="Dyne.org">
	</a>
</p>


# DDDC pilot Zencode contracts

This repository is meant to hold all the necessary **smart contracts** for the DDDC Barcelona Pilot. The smart contracts are written in zencode and will run over zenroom.

The main use case for Zenroom is that of **distributed computing** of untrusted code where advanced cryptographic functions are required, for instance it can be used as a distributed ledger implementation (also known as **blockchain smart contracts**).

Zenroom is a software in **BETA stage** and are part of the [DECODE project](https://decodeproject.eu) about data-ownership and [technological sovereignty](https://www.youtube.com/watch?v=RvBRbwBm_nQ). Our effort is that of improving people's awareness of how their data is processed by algorithms, as well facilitate the work of developers to create along [privacy by design principles](https://decodeproject.eu/publications/privacy-design-strategies-decode-architecture) using algorithms that can be deployed in any situation without any change.

<details>
 <summary><strong>:triangular_flag_on_post: Table of Contents</strong> (click to expand)</summary>

* [Usage](#video_game-usage)
* [Testing](#wrench-testing)
* [Troubleshooting & debugging](#bug-troubleshooting--debugging)
* [Acknowledgements](#heart_eyes-acknowledgements)
* [Links](#globe_with_meridians-links)
* [License](#briefcase-license)
</details>


***
## :video_game: Usage

There are 8 script/contracts involved in the coconut credential process, but mainly we can divide them in two macro step:

  * Provisioning of the credential (Script 1-6) involves the citizen and the credential issuer (to run once)
  * Verification of blind proof credentials (Script 7, 8) involves the citizen and a verifier/checker

The provisioning is structured as follow:
  1. The citizen creates a `request blind signature` (Script 1, 2) that should be sent to the credential issuer
  2. The credential issuer validates and signs the `request blind signature` and generates a `blind signed credential` that should be sent back to the citizen (Scripts 3-5)
  3. The citizen with the `blind signed credential` generates the real `credential` that is verified by the credential issuer, that should be stored (Script 6)

The second step is the verification of blind proof that is structured as follows:
  1. Once the citizen holds a credential, could generate `blind proof of credentials` by using his secret info and credential issuer's public info (Script 7) and send to a checker/verifier
  2. A checker/verifier can verify the `blind proof of credentials` returning true or fail (Script 8)


### 01-CITIZEN-credential-keygen.zencode

| :symbols: INPUT PARAMS | :arrow_down: DATA | :closed_lock_with_key: KEYS | :page_with_curl: OUPUT | 
| :---------: | :---------: | :---------: | :---------: |
| **identifier** | :no_entry_sign: | :no_entry_sign: | Yes  (e.g. **keypair.keys**) |

This script should be run once, and the output should be saved in a secure place, it will contain the secret and public keyring of the citizen

*:running_woman: Expected result format*

```json
{"identifier":{"public":"...","private":"..."}}
```

### 02-CITIZEN-credential-request.zencode

| :symbols: INPUT PARAMS | :arrow_down: DATA | :closed_lock_with_key: KEYS | :page_with_curl: OUPUT | 
| :---------: | :---------: | :---------: | :---------: |
| **identifier** | :no_entry_sign: | output of **01-CITIZEN-credential-keygen** | Yes  (e.g. **blind_signature.req**) |
| **declared attributes** (e.g. I'm 18) | | | |

This contract creates a blind signature request to send to the credential issuer and **for each** declared attribute you should add `and I declare that I am` to the `zencode source`

The previous saved keypair from [01-CITIZEN-request-keypair.zencode](#01-CITIZEN-request-keypair.zencode) should be passed as the `KEYS` and the **identifier** should be the same of the one stored in such `KEYS`.
The output should be sent to the credential issuer to be signed.

*:running_woman: Expected result format*

```json
{
  "request": {
    "pi_s": {
      "rk": "...",
      "c": "...",
      "rr": "...",
      "rm": "..."
    },
    "c": {
      "b": "...",
      "a": "..."
    },
    "cm": "...",
    "public": "..."
  }
}
```

### 03-CREDENTIAL_ISSUER-keygen.zencode

| :symbols: INPUT PARAMS | :arrow_down: DATA | :closed_lock_with_key: KEYS | :page_with_curl: OUPUT | 
| :---------: | :---------: | :---------: | :---------: |
| **issuer_identifier** | :no_entry_sign: | :no_entry_sign: | Yes  (e.g. **issuer_keypair.keys**) |

This script should be run once, and the output should be saved in a secure place, it will contain the secret and public keyring of the credential_issuer

*:running_woman: Expected result format*

```json
{
   "issuer_identifier":{
      "sign":{
         "y":"...",
         "x":"..."
      },
      "verify":{
         "beta":"...",
         "g2":"...",
         "alpha":"..."
      }
   }
}
```

### 04-CREDENTIAL_ISSUER-publish-verifier.zencode

| :symbols: INPUT PARAMS | :arrow_down: DATA | :closed_lock_with_key: KEYS | :page_with_curl: OUPUT | 
| :---------: | :---------: | :---------: | :---------: |
| **issuer_identifier** | :no_entry_sign: | output of **03-CREDENTIAL_ISSUER-keygen** | Yes  (e.g. **issuer_verifier.keys**) |

This contract prints the public part of the verification keypair of the credential issuer, that should be available to the **checker**

*:running_woman: Expected result format*

```json
{
   "issuer_identifier":{
      "verify":{
         "beta":"...",
         "g2":"...",
         "alpha":"..."
      }
   }
}
```

### 05-CREDENTIAL_ISSUER-credential-sign.zencode

| :symbols: INPUT PARAMS | :arrow_down: DATA | :closed_lock_with_key: KEYS | :page_with_curl: OUPUT | 
| :---------: | :---------: | :---------: | :---------: |
| **issuer_identifier** | output of **02-CITIZEN-credential-request** | output of **03-CREDENTIAL_ISSUER-keygen** | Yes  (e.g. **issuer_signed_credential.json**) |

This contract takes as DATA the output of [02-CITIZEN-request-blind-signature.zencode](#src/02-CITIZEN-request-blind-signature.zencode) and the secret keypair of the credential issuer and emits a signed credential that should be send back to the citizen.

*:running_woman: Expected result format*

```json
{
  "issuer_identifier": {
    "a_tilde": "...",
    "schema": "coconut_sigmatilde",
    "b_tilde": "...",
    "version": "0.8.1",
    "h": "..."
  }
}
```


### 06-CITIZEN-aggregate-credential-signature.zencode

| :symbols: INPUT PARAMS | :arrow_down: DATA | :closed_lock_with_key: KEYS | :page_with_curl: OUPUT | 
| :---------: | :---------: | :---------: | :---------: |
| **identifier** | output of **05-CREDENTIAL_ISSUER-credential-sign** | output of **01-CITIZEN-credential-keygen** | Yes  (e.g. **credential.json**) |

This is the last step of the provisioning of the citizen. This contract creates a blind signed credential to be stored in a secure place.

*:running_woman: Expected result format*

```json
{
  "name": "identifier",
  "credential": {
    "h": "...",
    "schema": "coconut_aggsigma",
    "version": "0.8.1",
    "s": "..."
  }
}
```

### 07-CITIZEN-prove-credential.zencode

| :symbols: INPUT PARAMS | :arrow_down: DATA | :closed_lock_with_key: KEYS | :page_with_curl: OUPUT | 
| :---------: | :---------: | :---------: | :---------: |
| **identifier** | output of **06-CITIZEN-aggregate-credential-signature** | output of **04-CREDENTIAL_ISSUER-publish-verifier** | Yes  (e.g. **blindproof_credential.json**) |
| **issuer_identifier** | | | |
| **declared attributes** (e.g. I'm 18) | | | |

This is run by the citizen to create a valid blind proof of the credentials, should be then send to the checker/verifier

*:running_woman: Expected result format*

```json
{
  "proof": {
    "schema": "coconut_theta",
    "sigma_prime": {
      "s_prime": "...",
      "h_prime": "..."
    },
    "pi_v": {
      "rm": "...",
      "rr": "...",
      "c": "..."
    },
    "version": "0.8.1",
    "nu": "...",
    "kappa": "..."
  }
}
```

### 08-VERIFIER-verify-credential.zencode

| :symbols: INPUT PARAMS | :arrow_down: DATA | :closed_lock_with_key: KEYS | :page_with_curl: OUPUT | 
| :--------------------: | :---------------: | :-------------------------: | :--------------------: |
| **issuer_identifier**   | output of **04-CREDENTIAL_ISSUER-publish-verifier** | output of **07-CITIZEN-prove-credential** | :no_entry_sign: |

This verifies if a blind proof of credential is valid, in a success case just prints `OK` to stdout


### 09-CITIZEN-create-petition.zencode

| :symbols: INPUT PARAMS | :arrow_down: DATA | :closed_lock_with_key: KEYS | :page_with_curl: OUPUT | 
| :---------: | :---------: | :---------: | :---------: |
| **identifier** | output of **04-CREDENTIAL_ISSUER-publish-verifier.zencode** | output of **06-CITIZEN-aggregate-credential-signature.zencode** | Yes  (e.g. **petition_request.json**) |
| **issuer_identifier** | | | |
| **petition** (Pe) | | | |

Citizen creates a new petition, using his own key, the credential and the credential issuer's public.

*:running_woman: Expected result format*

```json


{
	"petition": {
		
		"owner": "...",
		"schema": "petition",
		"scores": {
				"neg": {
				"left": "Infinity",
				"right": "Infinity"
			},
			"pos": {
				"left": "Infinity",
				"right": "Infinity"
			},

		},
		"uid": "...",

	},
	"petition_ecdh_sign": ["..."],
	"proof": {
		"kappa": "",
		"nu": "",
		"pi_v": {
			"c": "",
			"rm": "",
			"rr": ""
		},
		"schema": "theta",
		"sigma_prime": {
			"h_prime": "",
			"s_prime": ""
		},

	},
	"verifier": {
		"alpha": "",
		"beta": "",
		"schema": "issue_verify",
	}
}
```



### 10-VERIFIER-approve-petition.zencode

| :symbols: INPUT PARAMS | :arrow_down: DATA | :closed_lock_with_key: KEYS | :page_with_curl: OUPUT | 
| :---------: | :---------: | :---------: | :---------: |
| **issuer_identifier** | output of **09-CITIZEN-create-petition.zencode** | output of **04-CREDENTIAL_ISSUER-publish-verifier.zencode  ** | Yes  (e.g. **petition.json**) |

Approve the creation of a petition: executed by a Citizen, using several keys.

*:running_woman: Expected result format*

```json

{
	"petition": {
		"list": {
			"...": true,
			"...": true,
			"...": true
		},
		"owner": "...",
		"schema": "petition",
		"scores": {
			"neg": {
				"left": "",
				"right": ""
			},
			"pos": {
				"left": "",
				"right": ""
			},

		},
		"uid": "...",

	},
	"verifier": {
		"alpha": "",
		"beta": "",
		"schema": "issue_verify",
	}
}


```


***

## :wrench: Testing

```bash
docker build -t dddc-pilot-contracts .
docker run --rm -it dddc-pilot-contracts
```

***
## :bug: Troubleshooting & debugging

### Debug mode
To run the `zencode` contracts in a more verbose way, you should change the source code

    ZEN:begin(1)

to reset it to silent mode change with

    ZEN:begin(0)

***
## :heart_eyes: Acknowledgements

Copyright :copyright: 2019 by [Dyne.org](https://www.dyne.org) foundation, Amsterdam

Designed, written and maintained by Puria Nafisi Azizi and Denis "Jaromil" Rojo.

Special thanks to Andrea "Bario" D'Intino for his expert reviews.

<img src="https://zenroom.dyne.org/img/ec_logo.png" class="pic" alt="Project funded by the European Commission">

This project is receiving funding from the European Union’s Horizon 2020 research and innovation programme under grant agreement nr. 732546 (DECODE).


***
## :globe_with_meridians: Links

https://www.decidim.barcelona/

https://zenroom.dyne.org/

https://decodeproject.eu/




***
## :briefcase: License

	DDDC Smart Contracts
    Copyright :copyright: 2019 Dyne.org foundation, Amsterdam

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Affero General Public License as
	published by the Free Software Foundation, either version 3 of the
	License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU Affero General Public License for more details.

	You should have received a copy of the GNU Affero General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
