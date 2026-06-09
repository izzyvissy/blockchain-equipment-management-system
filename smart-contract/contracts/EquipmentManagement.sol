// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title Equipment Management System (EMS) - Blockchain DApp
/// @notice Manages equipment borrowing lifecycle: Available → Requested → Borrowed → Available
contract EquipmentManagement {

    // ─────────────────────────────────────────────
    //  ENUMS & STRUCTS
    // ─────────────────────────────────────────────

    enum Status { Available, Requested, Borrowed }

    struct Equipment {
        uint256 id;
        string  name;
        string  category;
        Status  status;
        address borrower;
        bool    exists;
    }

    // ─────────────────────────────────────────────
    //  STATE VARIABLES
    // ─────────────────────────────────────────────

    address public owner;                          // Contract deployer
    uint256 public equipmentCount;

    mapping(uint256 => Equipment) private equipments;
    mapping(address => bool)      public  admins;

    // ─────────────────────────────────────────────
    //  EVENTS
    // ─────────────────────────────────────────────

    event EquipmentAdded    (uint256 indexed id, string name, string category);
    event BorrowRequested   (uint256 indexed id, address indexed borrower);
    event RequestApproved   (uint256 indexed id, address indexed approvedBy);
    event EquipmentReturned (uint256 indexed id, address indexed returnedBy);
    event AdminAdded        (address indexed admin);
    event AdminRemoved      (address indexed admin);

    // ─────────────────────────────────────────────
    //  MODIFIERS
    // ─────────────────────────────────────────────

    modifier onlyOwner() {
        require(msg.sender == owner, "Not contract owner");
        _;
    }

    modifier onlyAdmin() {
        require(admins[msg.sender] || msg.sender == owner, "Not an admin");
        _;
    }

    modifier equipmentExists(uint256 _id) {
        require(_id > 0 && _id <= equipmentCount && equipments[_id].exists, "Equipment not found");
        _;
    }

    // ─────────────────────────────────────────────
    //  CONSTRUCTOR
    // ─────────────────────────────────────────────

    constructor() {
        owner = msg.sender;
        admins[msg.sender] = true;

        // Pre-load the 10 equipment items matching the UI
        _addEquipment("Projector Epson X200",    "Display");
        _addEquipment("Wireless Microphone",      "Audio");
        _addEquipment("Extension Cable",          "Power");
        _addEquipment("Smart Whiteboard",         "Presentation");
        _addEquipment("55-inch TV Monitor",       "Display");
        _addEquipment("Portable Speaker System",  "Audio");
        _addEquipment("HDMI Adapter",             "Accessory");
        _addEquipment("DSLR Camera Canon",        "Media");
        _addEquipment("Plastic Chair",            "Furniture");
        _addEquipment("Folding Table",            "Furniture");
    }

    // ─────────────────────────────────────────────
    //  INTERNAL
    // ─────────────────────────────────────────────

    function _addEquipment(string memory _name, string memory _category) internal {
        equipmentCount++;
        equipments[equipmentCount] = Equipment({
            id       : equipmentCount,
            name     : _name,
            category : _category,
            status   : Status.Available,
            borrower : address(0),
            exists   : true
        });
        emit EquipmentAdded(equipmentCount, _name, _category);
    }

    // ─────────────────────────────────────────────
    //  ADMIN MANAGEMENT
    // ─────────────────────────────────────────────

    /// @notice Owner can grant admin rights to any address (supports multiple admins)
    function addAdmin(address _admin) external onlyOwner {
        require(_admin != address(0), "Invalid address");
        require(!admins[_admin], "Already an admin");
        admins[_admin] = true;
        emit AdminAdded(_admin);
    }

    /// @notice Owner can revoke admin rights
    function removeAdmin(address _admin) external onlyOwner {
        require(_admin != owner, "Cannot remove owner");
        admins[_admin] = false;
        emit AdminRemoved(_admin);
    }

    // ─────────────────────────────────────────────
    //  EQUIPMENT MANAGEMENT (ADMIN)
    // ─────────────────────────────────────────────

    /// @notice Admin can add new equipment beyond the initial 10
    function addEquipment(string memory _name, string memory _category) external onlyAdmin {
        _addEquipment(_name, _category);
    }

    // ─────────────────────────────────────────────
    //  BORROW LIFECYCLE
    // ─────────────────────────────────────────────

    /// @notice Any wallet can request to borrow an available equipment
    function requestBorrow(uint256 _id) external equipmentExists(_id) {
        Equipment storage eq = equipments[_id];
        require(eq.status == Status.Available, "Equipment is not available");
        require(!admins[msg.sender] && msg.sender != owner, "Admins cannot borrow");

        eq.status   = Status.Requested;
        eq.borrower = msg.sender;

        emit BorrowRequested(_id, msg.sender);
    }

    /// @notice Admin approves a borrow request
    function approveRequest(uint256 _id) external onlyAdmin equipmentExists(_id) {
        Equipment storage eq = equipments[_id];
        require(eq.status == Status.Requested, "No pending request for this equipment");

        eq.status = Status.Borrowed;

        emit RequestApproved(_id, msg.sender);
    }

    /// @notice Borrower returns the equipment
    function returnEquipment(uint256 _id) external equipmentExists(_id) {
        Equipment storage eq = equipments[_id];
        require(eq.status == Status.Borrowed, "Equipment is not currently borrowed");
        require(eq.borrower == msg.sender || admins[msg.sender] || msg.sender == owner,
                "Only borrower or admin can return");

        eq.status   = Status.Available;
        eq.borrower = address(0);

        emit EquipmentReturned(_id, msg.sender);
    }

    // ─────────────────────────────────────────────
    //  VIEW FUNCTIONS  (called by app.js)
    // ─────────────────────────────────────────────

    /// @notice Get equipment details — matches ABI in app.js exactly
    function getEquipment(uint256 _id)
        external
        view
        equipmentExists(_id)
        returns (string memory name, string memory status, address borrower)
    {
        Equipment storage eq = equipments[_id];

        string memory statusStr;
        if      (eq.status == Status.Available)  statusStr = "Available";
        else if (eq.status == Status.Requested)  statusStr = "Requested";
        else                                      statusStr = "Borrowed";

        return (eq.name, statusStr, eq.borrower);
    }

    /// @notice Get full equipment details including category
    function getEquipmentFull(uint256 _id)
        external
        view
        equipmentExists(_id)
        returns (
            uint256 id,
            string memory name,
            string memory category,
            string memory status,
            address borrower
        )
    {
        Equipment storage eq = equipments[_id];

        string memory statusStr;
        if      (eq.status == Status.Available)  statusStr = "Available";
        else if (eq.status == Status.Requested)  statusStr = "Requested";
        else                                      statusStr = "Borrowed";

        return (eq.id, eq.name, eq.category, statusStr, eq.borrower);
    }

    /// @notice Dashboard stats — Total, Available, Borrowed, Pending
    function getStats()
        external
        view
        returns (
            uint256 total,
            uint256 available,
            uint256 borrowed,
            uint256 pending
        )
    {
        total = equipmentCount;
        for (uint256 i = 1; i <= equipmentCount; i++) {
            if      (equipments[i].status == Status.Available)  available++;
            else if (equipments[i].status == Status.Borrowed)   borrowed++;
            else if (equipments[i].status == Status.Requested)  pending++;
        }
    }

    /// @notice Get total equipment count
    function getTotalEquipment() external view returns (uint256) {
        return equipmentCount;
    }
}
