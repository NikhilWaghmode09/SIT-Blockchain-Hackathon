// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

contract VoteSys{
    struct Voter 
    {
        uint age; //stores the age of the voter.
        uint party_id; //stores the id of choosen party.
        bool hasVoted; //to check if voter has already voted.

    }
    address admin; //stores admin address.

    string[] internal parties; //string array to store party names.

    //mapping to store vote counts of parties.
    mapping(string => uint256) internal voteCounts;

    //constructor to perform primary operations.
    constructor(string[] memory _parties) {
        for (uint i = 0; i < _parties.length; i++) {
            parties.push(_parties[i]); //pushes party names to array.
            voteCounts[_parties[i]] = 0; //initializes voteCounts mapping to 0.
        }
        admin = msg.sender; //sets deployer address as admin.
    }
    
    //function to add new parties. Limited to Admin.
    function addParty(string memory partyName) public{
        require(admin == msg.sender,"Only the admin can add parties");
        parties.push(partyName);
        voteCounts[partyName] = 0;
    }

    //function returns party names and there respective ids.
    function getPartyNames() public view returns (string[] memory, uint[] memory) {
        uint[] memory partyIndices = new uint[](parties.length); //dynamic int array to maintain party_ids.

        for (uint i = 0; i < parties.length; i++) {
            partyIndices[i] = i;
        }

        return (parties, partyIndices);
        
    }

    //voters mapping for mapping address to the structure 
    mapping(address => Voter) internal voters;
    //internal is used to prevent other smart contracts from accessing the voters mapping except derived contracts.

    //event for vote casting.
    event VoteCasted(address indexed voter, uint indexed party_id, uint age);
    
    //function to cast the vote.
    function cast_vote(uint vote, uint _age) public {
        require(voters[msg.sender].hasVoted == false, "You have already voted!"); //a voter can only vote once.
        require(vote < parties.length, "You have entered an incorrect party_id"); //invalid party_id.
        require(_age >= 18, "You must be at least 18 years old to vote."); //age requirement.

        voters[msg.sender].hasVoted = true; 
        voters[msg.sender].party_id = vote; //stores voters selected party.
        voters[msg.sender].age = _age; //store the age of the voter.
        voteCounts[parties[vote]]++;  //increments the vote count of that party.
        
        emit VoteCasted(msg.sender, vote, _age); 
    }
    
    //function to check the winning party. View only function.
    function winning_party() public view returns (string memory, uint) {
        string memory winningParty = parties[0]; //first party would be the default winner.
        uint winningVotes = voteCounts[parties[0]]; //stores vote count of winning party.

        for (uint i = 0; i < parties.length; i++) {
            if (voteCounts[parties[i]] > winningVotes) {
                winningParty = parties[i]; //winning party.
                winningVotes = voteCounts[parties[i]]; //winning party's vote count.
            }
        }
        return (winningParty, winningVotes); 
    }
}