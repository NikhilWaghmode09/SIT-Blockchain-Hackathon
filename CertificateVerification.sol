// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract CertificateVerification {
    //structure to represent academic certificates.
    struct Certificate {
        string studentName; //stores student name.
        string degree; //stores student degree.
        uint issuanceDate; //stores date of issuance in ddmmyy format.
        bool isVerified; //flag to check is the certificate is verified.
    }

    //mapping to link student addresses with their certificates.
    mapping(address => Certificate) public certificates;

    //mapping to keep track of authorized certificate verifiers.
    mapping(address => bool) public authorizedVerifiers;

    // Event to record the issuance of certificates
    event CertificateIssued(address indexed studentAddress, string studentName, string degree, uint issuanceDate);

    // Event to record certificate verification
    event CertificateVerified(address indexed verifier, address indexed studentAddress);

    //constructor to set up authorized certificate verifiers
    constructor(address[] memory verifiers) {
        authorizedVerifiers[msg.sender] = true; //default validator will be admin(deployer).

        for (uint i = 0; i < verifiers.length; i++) {
            authorizedVerifiers[verifiers[i]] = true; //extra validators.
        }
    }

    //function for educational institutions (administrators) to issue certificates
    function issueCertificate(
        address studentAddress,
        string memory studentName,
        string memory degree,
        uint256 issuanceDate
    ) public {
        require(authorizedVerifiers[msg.sender], "Only authorized institutions can issue certificates.");
        require(bytes(certificates[studentAddress].studentName).length == 0, "Certificate has already been issued.");

        certificates[studentAddress] = Certificate(studentName, degree, issuanceDate, false);
        emit CertificateIssued(studentAddress, studentName, degree, issuanceDate);
    }

    //function for anyone to verify the legitimacy of a certificate.
    function verifyCertificate(address studentAddress) public view returns (bool) {
        Certificate memory certificate = certificates[studentAddress];
        return bytes(certificate.studentName).length > 0 && certificate.isVerified;
    }

    //function for authorized verifiers to mark a certificate as verified
    function markAsVerified(address studentAddress) public {
        require(authorizedVerifiers[msg.sender], "Only authorized verifiers can confirm certificate validity.");
        require(bytes(certificates[studentAddress].studentName).length > 0, "Certificate does not exist.");
        require(!certificates[studentAddress].isVerified, "Certificate has already been verified.");

        certificates[studentAddress].isVerified = true;
        emit CertificateVerified(msg.sender, studentAddress);
    }
}
