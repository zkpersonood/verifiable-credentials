// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IVerifiableCredential {
    struct Credential {
        bytes32 schemaHash;
        address issuer;
        address subject;
        bytes32 dataHash;
        uint256 validFrom;
        uint256 validUntil;
    }

    function issueCredential(address subject, bytes32 schemaHash, bytes32 dataHash, uint256 validUntil, bytes calldata proof) external;
    function revokeCredential(bytes32 credentialId) external;
    function verifyCredential(bytes32 credentialId, bytes calldata proof) external view returns (bool);
    function getCredential(bytes32 credentialId) external view returns (Credential memory);
}
