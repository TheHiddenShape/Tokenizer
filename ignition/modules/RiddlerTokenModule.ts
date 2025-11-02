// ignition/modules/RiddlerTokenModule.ts
import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

export default buildModule("RiddlerTokenModule", (m) => {
  // retrieves the first account configured in Hard Hat (deploy)
  const deployer = m.getAccount(0);

  // supply in BigInt (1_000_000 * 10**18)
  const initialSupply = 1_000_000n * 10n ** 18n;

  // Requests the deployment of the RiddlerToken contract with the initialSupply argument
  // You can explicitly pass "from: deployer" in the options
  const riddler = m.contract("RiddlerToken", [initialSupply], {
    from: deployer,
  });

  // exposes the instance for testing / other modules
  return { riddler };
});