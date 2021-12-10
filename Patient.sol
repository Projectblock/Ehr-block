pragma solidity ^0.6.6;

contract Patient {

    struct patientData {
        address ownerPatient;
        address id;
        string name;
        string contact;
        string email;
        uint fileCount;
        uint doctorCount;
        string decryptionKey;
    }

    struct fileData {
        string fileName;
        string fileHash;
        string datetime;
    }

    struct doctorData {
        address doctorAcc;
        string docName;
    }

    mapping (address => patientData) private patients;
    mapping (address => mapping (uint => fileData)) private files;
    mapping (address => mapping (uint => doctorData)) public doctors;
    mapping (address => bool) canView;

    constructor( address _patient, address _doctor,string memory _key) public {
        canView[_doctor] = true;
        canView[_patient] = true;
        decryptionKey = _key;
    }

    function addPatient(address _id, string memory _name, string memory _contact, string memory _email) private {
        patientData storage p = patients[msg.sender];
        p.id = _id;
        p.name = _name;
        p.contact = _contact;
        p.email = _email;
        p.fileCount = 0;
        p.doctorCount = 0;
    }

    function saveFile(string memory _fname, string memory _fhash, string memory _datetime) private {
        patientData storage p = patients[msg.sender];
        files[msg.sender][p.fileCount] = fileData(_fname, _fhash, _datetime);
        p.fileCount ++;
    }

    function saveDoctor(string memory _docName, address _doctorAcc) public {
        patientData storage p = patients[msg.sender];
        doctors[msg.sender][p.doctorCount] = doctorData(_doctorAcc, _docName);
        p.doctorCount ++;
    }
    function giveViewPermission(address viewer) public{
        require(msg.sender == Patient, "Only patient can give permission!!");
        //require(canView[viewer] == false, "Already has viewing rights!!");
        canView[viewer] = true;
    }
    function revokeViewPermission(address viewer) public{
        require(msg.sender == Patient, "Only patient can revoke permission!!");
        require(canView[viewer] == true, "No need to revoke!!");
        canView[viewer] = false;
    }
   
    function getDecryptionKey() public view returns(string memory){
        require(canView[msg.sender] == true, "You do not have viewing rights!!");
        return decryptionKey;
    }

}