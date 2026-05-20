# EMS Blockchain System

A blockchain-based Equipment Management System (EMS) developed as a decentralized application (DApp) for managing equipment borrowing and returning activities in universities, labs, and event management environments.

The project uses blockchain technology to provide:
- Transparent transaction records
- Immutable borrowing history
- Wallet-based authentication
- Secure smart contract automation

---

# Project Overview

Traditional inventory systems usually rely on centralized databases and manual record keeping. This can lead to:
- Data inconsistency
- Manipulation of records
- Missing transaction history
- Delayed updates
- Lack of accountability

The EMS Blockchain System solves these problems by using smart contracts and blockchain technology to manage equipment transactions securely and transparently.

All borrowing activities are recorded on-chain, making the system more trustworthy and auditable.

---

# Key Features

## User Features
- Connect wallet using MetaMask
- Request equipment borrowing
- View borrowing status
- View blockchain transaction history

---

## Administrator Features
- Approve borrowing requests
- Manage equipment inventory
- Monitor borrowing activities
- Verify blockchain records

---

## Storekeeper Features
- Confirm equipment return
- Validate equipment condition
- Track active borrowings

---

# System Architecture

The system follows a decentralized application (DApp) architecture.

```text
User
   ↓
Frontend Interface (HTML / JavaScript)
   ↓
MetaMask Wallet
   ↓
Smart Contract (Solidity)
   ↓
Polygon Blockchain Network
```

---

# Technology Stack

| Component | Technology |
|---|---|
| Frontend | HTML, CSS, JavaScript |
| Smart Contract | Solidity |
| Blockchain Network | Polygon Amoy Testnet |
| Wallet Integration | MetaMask |
| Blockchain Interaction | Ethers.js |
| Development Environment | Hardhat |
| IDE | Visual Studio Code |

---

# Project Structure

```text
ems-blockchain-system/
│
├── smart-contract/
│   ├── contracts/
│   ├── scripts/
│   ├── test/
│   └── hardhat.config.js
│
├── frontend/
│   ├── index.html
│   └── app.js
│
├── docs/
│
└── README.md
```

---

# Core Roles

The system contains three main user roles.

| Role | Responsibilities |
|---|---|
| Administrator | Approve requests and manage equipment |
| Storekeeper | Validate returns and equipment condition |
| User | Request and return equipment |

---

# Equipment Workflow

The borrowing workflow follows several equipment states.

```text
Available
↓
Requested
↓
Approved
↓
Borrowed
↓
Returned
```

Each state transition is recorded on the blockchain.

---

# Smart Contract Functions

The EMS smart contract contains the following core functions.

```solidity
requestBorrow(uint256 _id)
approveRequest(uint256 _id)
returnEquipment(uint256 _id)
getEquipment(uint256 _id)
```

---

# Frontend Features

The frontend provides:
- Wallet connection
- Equipment inventory display
- Borrow request buttons
- Approval actions
- Return actions
- Blockchain transaction history

---

# Wallet Integration

The system uses MetaMask for:
- User authentication
- Wallet connection
- Transaction signing
- Blockchain interaction

Transaction flow:

```text
Frontend Action
↓
MetaMask Confirmation
↓
Smart Contract Execution
↓
Blockchain Update
↓
Frontend Refresh
```

---

# Development Workflow

The project follows the Agile software development model.

Development phases:
1. Environment Setup
2. Smart Contract Development
3. Local Blockchain Testing
4. Wallet Integration
5. Frontend Development
6. Polygon Deployment
7. Final Testing

---

# Required Software

All team members should install the following software before development.

---

## 1. Visual Studio Code

Download:
https://code.visualstudio.com/

Recommended Extensions:
- Solidity
- ESLint
- Prettier
- GitLens

---

## 2. Node.js

Download:
https://nodejs.org/

Verify installation:

```bash
node -v
npm -v
```

---

## 3. Git

Download:
https://git-scm.com/

Verify installation:

```bash
git --version
```

---

## 4. MetaMask

Download:
https://metamask.io/

Each member should:
- Create a wallet
- Save recovery phrase securely

---

# Hardhat Setup

Navigate into the smart contract directory:

```bash
cd smart-contract
```

Initialize npm:

```bash
npm init -y
```

Install Hardhat:

```bash
npm install --save-dev hardhat
```

Initialize Hardhat project:

```bash
npx hardhat
```

Select:

```text
Create a JavaScript project
```

---

# Running Local Blockchain

Start local Hardhat blockchain:

```bash
npx hardhat node
```

This will:
- Create a local blockchain network
- Generate testing wallets
- Provide testing private keys

---

# GitHub Workflow

## Main Branch

```text
main
```

Contains stable project code.

---

## Feature Branches

Each team member should use their own branch.

Examples:

```text
feature-smart-contract
feature-wallet
feature-frontend
feature-testing
```

---

# Basic Git Commands

Clone repository:

```bash
git clone <repository-url>
```

Create new branch:

```bash
git checkout -b feature-name
```

Commit changes:

```bash
git add .
git commit -m "commit message"
```

Push branch:

```bash
git push origin feature-name
```

---

# Current MVP Scope

The Minimum Viable Product (MVP) should support:

- Equipment registration
- Borrow request submission
- Request approval
- Equipment return
- Blockchain transaction recording

---

# Future Enhancements

Possible future improvements:
- QR code verification
- Equipment reputation tracking
- Penalty system
- Notification system
- Analytics dashboard
- Mobile support

---

# Team Responsibilities

| Member | Responsibility |
|---|---|
| Member 1 | Smart Contract Development |
| Member 2 | Blockchain Deployment & Hardhat |
| Member 3 | Wallet Integration |
| Member 4 | Frontend Development & Testing |

---

# Important Notes

- Blockchain acts as the primary database
- Smart contracts contain the core business logic
- Wallet addresses represent user identity
- Frontend only acts as an interaction layer
- All sensitive logic must be validated in Solidity

---

# Course Information

Course:
BICS 4336 — Blockchain and Application

Project:
Blockchain-Based Equipment Management System (EMS)

Academic Session:
2025 / 2026

---