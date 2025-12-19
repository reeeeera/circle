import { ethers } from "hardhat";
import * as dotenv from "dotenv";
import * as fs from "fs";
import * as path from "path";

dotenv.config();

async function main() {
  const [deployer] = await ethers.getSigners();
  
  console.log("Deploying contracts...");
  const balance = await ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", ethers.formatEther(balance), "ETH");
  console.log("Deployer address:", deployer.address);
  
  const contracts: Record<string, string> = {};
    // Deploy EventPlanner
  const EventPlannerFactory = await ethers.getContractFactory("EventPlanner");
  const eventPlanner = await EventPlannerFactory.deploy();
  await eventPlanner.waitForDeployment();
  const eventPlannerAddress = await eventPlanner.getAddress();
  contracts["EventPlanner"] = eventPlannerAddress;
  console.log("EventPlanner deployed to:", eventPlannerAddress);
  // Deploy GroupManager
  const GroupManagerFactory = await ethers.getContractFactory("GroupManager");
  const groupManager = await GroupManagerFactory.deploy();
  await groupManager.waitForDeployment();
  const groupManagerAddress = await groupManager.getAddress();
  contracts["GroupManager"] = groupManagerAddress;
  console.log("GroupManager deployed to:", groupManagerAddress);
  // Summary
  console.log("\n" + "=".repeat(60));
  console.log("Deployment Summary");
  console.log("=".repeat(60));
  for (const [name, address] of Object.entries(contracts)) {
    console.log(name + ":", address);
  }
  console.log("=".repeat(60));
  
  // Save to contracts.json
  const contractsPath = path.join(__dirname, "..", "contracts.json");
  fs.writeFileSync(contractsPath, JSON.stringify(contracts, null, 2));
  console.log("\nContract addresses saved to contracts.json");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
