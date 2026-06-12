import hre from "hardhat";

async function main() {
    console.log("Deploying EquipmentManagement contract...");

    const EquipmentManagement =
        await hre.ethers.getContractFactory("EquipmentManagement");

    const equipmentManagement =
        await EquipmentManagement.deploy();

    await equipmentManagement.waitForDeployment();

    const contractAddress =
        await equipmentManagement.getAddress();

    console.log("EquipmentManagement deployed to:", contractAddress);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});