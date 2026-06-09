# Verifiable Credentials

An on-chain verifiable credential (VC) system compatible with W3C standards. Issue, verify, and revoke credentials on-chain with zero-knowledge privacy.

## Overview

This protocol implements a decentralized credential ecosystem where:

- **Issuers** can issue verifiable credentials to subjects
- **Subjects** can prove they hold valid credentials without revealing content
- **Verifiers** can check credential validity, issuer trust, and expiration on-chain
- **Revocation** is transparent and immediately visible to all verifiers

### Credential Lifecycle

```
    Issue          Verify          Revoke
┌─────────┐   ┌────────────┐   ┌─────────┐
│ Issuer  │──▶│ On-Chain   │──▶│          │
│ creates │   │ Registry   │   │ Issuer  │
│ VC      │   │ stores VC  │   │ revokes │
└─────────┘   └────────────┘   └─────────┘
                   │
                   ▼
           ┌──────────────┐
           │ Third-party   │
           │ verifier      │
           │ checks status │
           └──────────────┘
```

## Architecture

```
┌──────────────────────────────────────────────────────────┐
│              VerifiableCredentialRegistry                  │
├──────────────────────────────────────────────────────────┤
│ Stores credential structs with:                          │
│ · schemaHash — identifies credential type/schema         │
│ · issuer — address of the issuing entity                │
│ · subject — address the credential is about              │
│ · dataHash — commitment to the actual credential data    │
│ · validFrom / validUntil — time-bound validity          │
├──────────────────────────────────────────────────────────┤
│ + issueCredential(subject, schema, dataHash, until, proof)│
│ + revokeCredential(credentialId)                         │
│ + verifyCredential(credentialId, proof) → bool           │
│ + getCredential(credentialId) → Credential               │
└──────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────┐
│                    IdentityHub                             │
├──────────────────────────────────────────────────────────┤
│ Trust management — users control which issuers to trust  │
├──────────────────────────────────────────────────────────┤
│ + trustIssuer(issuer)                                     │
│ + revokeIssuer(issuer)                                    │
│ + isIssuerTrusted(user, issuer) → bool                   │
└──────────────────────────────────────────────────────────┘
```

## Contracts

| Contract | Description |
|----------|-------------|
| **VerifiableCredentialRegistry.sol** | Core contract — manages the full credential lifecycle: issuance, verification, and revocation |
| **IdentityHub.sol** | Trust management — allows users to manage which issuers they trust |

## Credential Schema

Credentials follow a structured format:

```solidity
struct Credential {
    bytes32 schemaHash;     // Hash identifying the credential schema
    address issuer;         // Entity that issued the credential
    address subject;        // Entity the credential is about
    bytes32 dataHash;       // Hash of the credential data (privacy-preserving)
    uint256 validFrom;      // Timestamp when credential becomes valid
    uint256 validUntil;     // Timestamp when credential expires
}
```

## Getting Started

### Installation

```bash
git clone https://github.com/zkpersonood/verifiable-credentials.git
cd verifiable-credentials
npm install
npx hardhat compile
npx hardhat test
```

### Example: Issuing a Credential

```javascript
const schemaHash = ethers.keccak256(ethers.toUtf8Bytes("membership-v1"));
const dataHash = ethers.keccak256(ethers.toUtf8Bytes("member-of:community-dao"));
const validUntil = Math.floor(Date.now() / 1000) + 365 * 86400; // 1 year
const proof = "0x" + "ff".repeat(32);

await registry.issueCredential(
    subjectAddress,
    schemaHash,
    dataHash,
    validUntil,
    proof
);
```

### Deploy

```bash
npx hardhat run scripts/deploy.js --network sepolia
```

## Use Cases

- **Decentralized Identity** — Self-sovereign identity with on-chain verification
- **Employment Verification** — Issue and verify employment credentials
- **Education Credentials** — On-chain degrees and certifications
- **Membership Management** — DAO membership credentials
- **Compliance** — Verified credentials for regulated DeFi protocols

## License

MIT
