pragma solidity ^0.8.0;

contract SecureWoT {
    
    // Struct to store device information
    struct Device {
        address deviceAddress;
        bool isRegistered;
        // Additional device-specific information
        // ...
    }
    
    // Mapping to store devices
    mapping(address => Device) public devices;
    
    // Mapping to store access permissions
    mapping(address => mapping(address => bool)) public accessPermissions;
    
    // Mapping to store data hashes
    mapping(bytes32 => bool) public dataHashes;
    
    // Event emitted when a new device is registered
    event DeviceRegistered(address indexed deviceAddress);
    
    // Modifier to check if the device is registered
    modifier onlyRegisteredDevice() {
        require(devices[msg.sender].isRegistered, "Device is not registered.");
        _;
    }
    
    // Function to register a new device
    function registerDevice() public {
        require(!devices[msg.sender].isRegistered, "Device is already registered.");
        
        devices[msg.sender] = Device(msg.sender, true);
        
        emit DeviceRegistered(msg.sender);
    }
    
    // Function to grant access permission to a device
    function grantAccess(address _device) public onlyRegisteredDevice {
        accessPermissions[msg.sender][_device] = true;
    }
    
    // Function to revoke access permission from a device
    function revokeAccess(address _device) public onlyRegisteredDevice {
        accessPermissions[msg.sender][_device] = false;
    }
    
    // Function to verify data integrity
    function verifyData(bytes32 _dataHash) public view returns (bool) {
        return dataHashes[_dataHash];
    }
    
    // Function to store data with integrity verification
    function storeData(bytes32 _dataHash) public onlyRegisteredDevice {
        require(!dataHashes[_dataHash], "Data already stored.");
        
        dataHashes[_dataHash] = true;
    }
}
