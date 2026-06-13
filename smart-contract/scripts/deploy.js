const hre = require("hardhat");

async function main() {
  console.log("Deploying EquipmentManagement...");

  const Factory = await hre.ethers.getContractFactory("EquipmentManagement");
  const ems = await Factory.deploy();

  await ems.waitForDeployment();

  const address = await ems.getAddress();
  console.log("Deployed to:", address);

  // -----------------------------
  // ADD EQUIPMENT DATA HERE
  // -----------------------------

  console.log("Adding equipment...");

  await ems.addEquipment("Projector Epson X200", "Display");
  await ems.addEquipment("Wireless Microphone", "Audio");
  await ems.addEquipment("Extension Cable", "Power");
  await ems.addEquipment("Smart Whiteboard", "Presentation");
  await ems.addEquipment("55-inch TV Monitor", "Display");
  await ems.addEquipment("Portable Speaker System", "Audio");
  await ems.addEquipment("HDMI Adapter", "Accessory");
  await ems.addEquipment("DSLR Camera Canon", "Media");
  await ems.addEquipment("Plastic Chair", "Furniture");
  await ems.addEquipment("Folding Table", "Furniture");

  console.log("All equipment added!");
}

main().catch((err) => {
  console.error(err);
  process.exitCode = 1;
});