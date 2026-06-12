// 🔴 Replace this with your deployed EMS contract address!
const CONTRACT_ADDRESS = "PASTE_YOUR_DEPLOYED_ADDRESS_HERE";

// ABI matching your Equipment Management System functions
// ⚠️ Update this after compiling your Solidity contract
const EMS_ABI = [
  "function requestBorrow(uint256 _id)",
  "function approveRequest(uint256 _id)",
  "function returnEquipment(uint256 _id)",
  "function getEquipment(uint256 _id) view returns (string memory name, string memory status, address borrower)"
];

let provider, signer, contract;

// 🔹 UI Element Selections
const connectBtn = document.querySelector('.wallet-btn');
const historyBox = document.querySelector('.history-box');

// 🔹 1. Connect MetaMask Wallet
async function connectWallet() {
  if (!window.ethereum) return alert("Please install MetaMask extension!");
  try {
    provider = new ethers.BrowserProvider(window.ethereum);
    const accounts = await provider.send("eth_requestAccounts", []);
    signer = await provider.getSigner();
    contract = new ethers.Contract(CONTRACT_ADDRESS, EMS_ABI, signer);

    // Update button UI
    connectBtn.innerText = ` Connected: ${accounts[0].slice(0,6)}...${accounts[0].slice(-4)}`;
    connectBtn.style.background = "#10b981";
    connectBtn.style.cursor = "default";
    
    // Attach listeners to all table buttons
    attachButtonListeners();
    addHistoryLog("✅ Wallet connected successfully.");
  } catch (error) {
    console.error("Wallet connection failed:", error);
    alert("Connection rejected or failed.");
  }
}

// 🔹 2. Attach Click Listeners to Existing Table Buttons
function attachButtonListeners() {
  const rows = document.querySelectorAll('tbody tr');
  rows.forEach((row) => {
    const equipmentId = Number(row.dataset.id);

    const statusSpan = row.querySelector('.status');

    // Borrower is now the 5th column
    const borrowerCell = row.querySelector('td:nth-child(5)');
    
    const requestBtn = row.querySelector('.request-btn');
    const approveBtn = row.querySelector('.approve-btn');
    const returnBtn = row.querySelector('.return-btn');

    if (requestBtn) {
      requestBtn.addEventListener('click', async () => {
        await executeTx('requestBorrow', equipmentId, statusSpan, borrowerCell, requestBtn, 'Requested', '#fef9c3', '#854d0e');
      });
    }
    if (approveBtn) {
      approveBtn.addEventListener('click', async () => {
        await executeTx('approveRequest', equipmentId, statusSpan, borrowerCell, approveBtn, 'Borrowed', '#fee2e2', '#991b1b');
      });
    }
    if (returnBtn) {
      returnBtn.addEventListener('click', async () => {
        await executeTx('returnEquipment', equipmentId, statusSpan, borrowerCell, returnBtn, 'Available', '#dcfce7', '#166534');
      });
    }
  });
}

// 🔹 3. Execute Blockchain Transaction & Update UI
async function executeTx(functionName, equipmentId, statusEl, borrowerEl, btn, newStatusText, bgClass, colorHex) {
  if (!contract) return alert("Please connect your wallet first!");
  
  const originalText = btn.innerText;
  btn.innerText = "Processing...";
  btn.disabled = true;

  try {
    // Send transaction to contract
    const tx = await contract[functionName](equipmentId);
    btn.innerText = "Confirming on-chain...";
    await tx.wait(); // Wait for block confirmation (Hardhat 2 / Ethers v6 standard)

    // ✅ Update UI after success
    statusEl.className = `status ${functionName === 'requestBorrow' ? 'requested' : functionName === 'approveRequest' ? 'borrowed' : 'available'}`;
    statusEl.style.background = bgClass;
    statusEl.style.color = colorHex;
    statusEl.innerText = newStatusText;

    if (functionName === 'requestBorrow') {
      borrowerEl.innerText = await signer.getAddress();
    } else if (functionName === 'returnEquipment') {
      borrowerEl.innerText = "-";
    }

    addHistoryLog(`[BLOCK TX] ${functionName} executed for Equipment #${equipmentId}`);
    btn.innerText = "Done ✓";
    setTimeout(() => {
      btn.innerText = originalText;
      btn.disabled = false;
    }, 2000);

  } catch (error) {
    console.error(error);
    alert(`❌ Transaction failed: ${error.reason || error.message}`);
    btn.innerText = originalText;
    btn.disabled = false;
  }
}

// 🔹 4. Append to Transaction History Box
function addHistoryLog(message) {
  const entry = document.createElement('div');
  entry.innerHTML = `${message}<br><br>`;
  historyBox.prepend(entry);
}

// 🔹 Event Listeners
connectBtn.addEventListener('click', connectWallet);
