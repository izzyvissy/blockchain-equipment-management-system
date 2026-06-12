const hre = require("hardhat");

async function main() {
  console.log("Deploying EquipmentManagement...");

  const Factory = await hre.ethers.getContractFactory("EquipmentManagement");
  const contract = await Factory.deploy();

  await contract.waitForDeployment();

  console.log("Deployed to:", await contract.getAddress());
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});