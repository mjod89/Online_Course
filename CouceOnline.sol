pragma solidity ^0.8.0;

contract CertificateVerification {
    struct Certificate {
        string courseName;
        string completionDate;
        address owner;
        bool isRevoked;
    }
    
    mapping(bytes32 => Certificate) private certificates;
    
    address private administrator;
    
    modifier onlyAdministrator() {
        require(msg.sender == administrator, "Only the administrator can perform this action");
        _;
    }
    
    event CertificateIssued(bytes32 indexed certificateHash, string courseName, string completionDate, address indexed owner);
    event CertificateRevoked(bytes32 indexed certificateHash);
    
    constructor() {
        administrator = msg.sender;
    }
    
    function issueCertificate(bytes32 certificateHash, string memory courseName, string memory completionDate, address owner) public onlyAdministrator {
        require(certificates[certificateHash].owner == address(0), "Certificate already exists");
        
        certificates[certificateHash] = Certificate({
            courseName: courseName,
            completionDate: completionDate,
            owner: owner,
            isRevoked: false
        });
        
        emit CertificateIssued(certificateHash, courseName, completionDate, owner);
    }
    
    function revokeCertificate(bytes32 certificateHash) public onlyAdministrator {
        require(certificates[certificateHash].owner != address(0), "Certificate does not exist");
        require(!certificates[certificateHash].isRevoked, "Certificate already revoked");
        
        certificates[certificateHash].isRevoked = true;
        
        emit CertificateRevoked(certificateHash);
    }
    
    function verifyCertificate(bytes32 certificateHash) public view returns (bool) {
        require(certificates[certificateHash].owner != address(0), "Certificate does not exist");
        require(!certificates[certificateHash].isRevoked, "Certificate is revoked");
        
        return true;
    }
}
