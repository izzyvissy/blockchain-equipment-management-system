// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
|--------------------------------------------------------------------------
| Equipment Management System (EMS)
|--------------------------------------------------------------------------
| This smart contract handles:
| - Equipment registration
| - Borrow requests
| - Request approvals
| - Equipment returns
| - Basic role management
|
| Developed for:
| Blockchain-Based Equipment Management System Project
|--------------------------------------------------------------------------
*/

contract EquipmentManagement {

    /*
    |--------------------------------------------------------------------------
    | ENUMS
    |--------------------------------------------------------------------------
    | Enum is used to represent equipment status.
    | This is more efficient than using strings.
    |--------------------------------------------------------------------------
    */

    enum Status {
        Available,
        Requested,
        Borrowed
    }


    /*
    |--------------------------------------------------------------------------
    | STRUCTS
    |--------------------------------------------------------------------------
    | Struct stores equipment information.
    |--------------------------------------------------------------------------
    */

    struct Equipment {
        uint256 id;
        string name;
        string category;
        Status status;
        address borrower;
    }


    /*
    |--------------------------------------------------------------------------
    | STATE VARIABLES
    |--------------------------------------------------------------------------
    */

    // Contract owner (admin)
    address public admin;

    // Equipment counter
    uint256 public equipmentCount;

    // Store equipment using ID
    mapping(uint256 => Equipment) public equipments;


    /*
    |--------------------------------------------------------------------------
    | EVENTS
    |--------------------------------------------------------------------------
    | Events are logged on blockchain transaction history.
    | Useful for frontend tracking and debugging.
    |--------------------------------------------------------------------------
    */

    event EquipmentAdded(
        uint256 indexed id,
        string name,
        string category
    );

    event EquipmentRequested(
        uint256 indexed id,
        address indexed borrower
    );

    event RequestApproved(
        uint256 indexed id,
        address indexed borrower
    );

    event EquipmentReturned(
        uint256 indexed id,
        address indexed borrower
    );


    /*
    |--------------------------------------------------------------------------
    | MODIFIERS
    |--------------------------------------------------------------------------
    | Restrict function access.
    |--------------------------------------------------------------------------
    */

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }


    /*
    |--------------------------------------------------------------------------
    | CONSTRUCTOR
    |--------------------------------------------------------------------------
    | Runs once during contract deployment.
    |--------------------------------------------------------------------------
    */

    constructor() {
        admin = msg.sender;
    }


    /*
    |--------------------------------------------------------------------------
    | ADD EQUIPMENT
    |--------------------------------------------------------------------------
    | Admin registers new equipment into the system.
    |--------------------------------------------------------------------------
    */

    function addEquipment(
        string memory _name,
        string memory _category
    ) public onlyAdmin {

        equipmentCount++;

        equipments[equipmentCount] = Equipment({
            id: equipmentCount,
            name: _name,
            category: _category,
            status: Status.Available,
            borrower: address(0)
        });

        emit EquipmentAdded(
            equipmentCount,
            _name,
            _category
        );
    }


    /*
    |--------------------------------------------------------------------------
    | REQUEST BORROW
    |--------------------------------------------------------------------------
    | User requests available equipment.
    |--------------------------------------------------------------------------
    */

    function requestBorrow(uint256 _id) public {

        Equipment storage equipment = equipments[_id];

        // Ensure equipment exists
        require(equipment.id != 0, "Equipment does not exist.");

        // Ensure equipment is available
        require(
            equipment.status == Status.Available,
            "Equipment is not available."
        );

        // Update equipment status
        equipment.status = Status.Requested;

        // Save borrower address
        equipment.borrower = msg.sender;

        emit EquipmentRequested(_id, msg.sender);
    }


    /*
    |--------------------------------------------------------------------------
    | APPROVE REQUEST
    |--------------------------------------------------------------------------
    | Admin approves borrowing request.
    |--------------------------------------------------------------------------
    */

    function approveRequest(uint256 _id) public onlyAdmin {

        Equipment storage equipment = equipments[_id];

        require(
            equipment.status == Status.Requested,
            "Equipment is not requested."
        );

        // Change status to borrowed
        equipment.status = Status.Borrowed;

        emit RequestApproved(
            _id,
            equipment.borrower
        );
    }


    /*
    |--------------------------------------------------------------------------
    | RETURN EQUIPMENT
    |--------------------------------------------------------------------------
    | Borrower returns equipment.
    |--------------------------------------------------------------------------
    */

    function returnEquipment(uint256 _id) public {

        Equipment storage equipment = equipments[_id];

        require(
            equipment.status == Status.Borrowed,
            "Equipment is not borrowed."
        );

        // Optional:
        // Ensure only borrower can return equipment
        require(
            equipment.borrower == msg.sender,
            "Only borrower can return equipment."
        );

        // Reset equipment status
        equipment.status = Status.Available;

        // Clear borrower
        equipment.borrower = address(0);

        emit EquipmentReturned(_id, msg.sender);
    }


    /*
    |--------------------------------------------------------------------------
    | GET EQUIPMENT DETAILS
    |--------------------------------------------------------------------------
    | Returns equipment information.
    |--------------------------------------------------------------------------
    */

    function getEquipment(uint256 _id)
        public
        view
        returns (
            uint256,
            string memory,
            string memory,
            Status,
            address
        )
    {
        Equipment memory equipment = equipments[_id];

        return (
            equipment.id,
            equipment.name,
            equipment.category,
            equipment.status,
            equipment.borrower
        );
    }

}