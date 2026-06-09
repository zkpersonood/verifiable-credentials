# Verifiable Credentials

An on-chain verifiable credential registry with zero-knowledge privacy. Issue, verify, and revoke credentials without exposing underlying data.

## Contracts

- **VerifiableCredentialRegistry.sol** — Main contract for issuing, revoking, and verifying W3C-compatible credentials
- **IdentityHub.sol** — Trust management contract for managing trusted issuers

## Features

- Schema-based credential issuance
- On-chain verification with ZK proofs
- Credential revocation
- Issuer trust management
- Time-bound credentials with expiration

## Getting Started

```bash
npm install
npx hardhat compile
npx hardhat test
```
