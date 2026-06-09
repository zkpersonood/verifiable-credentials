// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IdentityHub {
    mapping(address => mapping(address => bool)) private trustedIssuers;
    mapping(address => bytes32[]) private userCredentials;

    event IssuerTrusted(address indexed user, address indexed issuer);
    event IssuerRevoked(address indexed user, address indexed issuer);

    function trustIssuer(address issuer) external {
        trustedIssuers[msg.sender][issuer] = true;
        emit IssuerTrusted(msg.sender, issuer);
    }

    function revokeIssuer(address issuer) external {
        trustedIssuers[msg.sender][issuer] = false;
        emit IssuerRevoked(msg.sender, issuer);
    }

    function isIssuerTrusted(address user, address issuer) external view returns (bool) {
        return trustedIssuers[user][issuer];
    }
}
