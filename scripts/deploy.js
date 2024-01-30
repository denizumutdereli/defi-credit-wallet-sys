const hre = require("hardhat");

async function main() {
  const Market = await hre.ethers.getContractFactory("Market");
  /** @ref {Link}
   * https://docs.aave.com/developers/deployed-contracts/v3-testnet-addresses
   */
  const market = await Market.deploy("......");

  await market.waitForDeployment();

  const address = await market.getAddress();
  console.log(`DNZCreditWallet Protocol contract deployed successfully to address ${address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});