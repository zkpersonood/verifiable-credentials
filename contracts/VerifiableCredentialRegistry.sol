// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IVerifiableCredential.sol";

contract VerifiableCredentialRegistry is IVerifiableCredential {
    mapping(bytes32 => Credential) private credentials;
    mapping(bytes32 => bool) private revoked;
    bytes32[] private credentialIds;

    event CredentialIssued(bytes32 indexed credentialId, address indexed subject);
    event CredentialRevoked(bytes32 indexed credentialId);

    function issueCredential(address subject, bytes32 schemaHash, bytes32 dataHash, uint256 validUntil, bytes calldata proof) external override {
        require(validUntil > block.timestamp, "Invalid expiration");
        require(verifyIssuerProof(schemaHash, dataHash, proof), "Invalid issuer proof");

        bytes32 credentialId = keccak256(abi.encodePacked(msg.sender, subject, schemaHash, block.timestamp));

        credentials[credentialId] = Credential({
            schemaHash: schemaHash,
            issuer: msg.sender,
            subject: subject,
            dataHash: dataHash,
            validFrom: block.timestamp,
            validUntil: validUntil
        });

        credentialIds.push(credentialId);
        emit CredentialIssued(credentialId, subject);
    }

    function revokeCredential(bytes32 credentialId) external override {
        require(credentials[credentialId].issuer == msg.sender, "Not issuer");
        require(!revoked[credentialId], "Already revoked");
        revoked[credentialId] = true;
        emit CredentialRevoked(credentialId);
    }

    function verifyCredential(bytes32 credentialId, bytes calldata proof) external view override returns (bool) {
        if (revoked[credentialId]) return false;
        Credential memory cred = credentials[credentialId];
        if (cred.validUntil < block.timestamp) return false;
        if (cred.issuer == address(0)) return false;
        return verifyCredentialProof(cred, proof);
    }

    function getCredential(bytes32 credentialId) external view override returns (Credential memory) {
        require(credentials[credentialId].issuer != address(0), "Not found");
        return credentials[credentialId];
    }

    function verifyIssuerProof(bytes32 schemaHash, bytes32 dataHash, bytes memory proof) internal pure returns (bool) {
        return proof.length >= 32 && schemaHash != bytes32(0) && dataHash != bytes32(0);
    }

    function verifyCredentialProof(Credential memory cred, bytes memory proof) internal pure returns (bool) {
        return proof.length >= 32 && cred.issuer != address(0);
    }
}
