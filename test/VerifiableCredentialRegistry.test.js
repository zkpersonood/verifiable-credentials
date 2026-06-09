const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("VerifiableCredentialRegistry", function () {
  let registry, owner, addr1;

  beforeEach(async function () {
    [owner, addr1] = await ethers.getSigners();
    const Registry = await ethers.getContractFactory("VerifiableCredentialRegistry");
    registry = await Registry.deploy();
    await registry.waitForDeployment();
  });

  it("should issue a credential", async function () {
    const schema = ethers.keccak256(ethers.toUtf8Bytes("schema-1"));
    const data = ethers.keccak256(ethers.toUtf8Bytes("data-1"));
    const proof = "0x" + "ff".repeat(32);
    const future = Math.floor(Date.now() / 1000) + 86400;

    await expect(registry.issueCredential(addr1.address, schema, data, future, proof))
      .to.emit(registry, "CredentialIssued");
  });
});
