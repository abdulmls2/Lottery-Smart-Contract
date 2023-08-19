//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Lottery {
    //manager, players, winner
    address public manager;
    address payable[] public players;
    address payable public winner;

    //the manager is the wallet that deploys the contract
    constructor() {
        manager = msg.sender;
    }

    //function to allow users to participate by paying the ammount required
    function participate() public payable{
        require(msg.value== 10000000000000000 wei, "Please pay 10000000000000000 wei");
        players.push(payable(msg.sender));
    }

    //function to get the balance of the lottery, only the manager can view the balance
    function getBalance() public view returns(uint) {
        require(manager==msg.sender, "You are not the manager"); 
        return address(this).balance;
    }

    //function to generate a random number, using this method here for now instead of an Oracle
    function random() internal view returns(uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, players.length)));
    }

    //function to pick the winner, only manager can call this function
    function pickWinner() public{
        require(manager==msg.sender, "You are not the manager");
        require(players.length>=3, "Not enough players, minimun 3 players needed");

        //simplifying the random generated number into the length of the array of the players
        uint r = random();
        uint index = r%players.length;

        winner = players[index];
        winner.transfer(getBalance());

        //restarting the lottery, new list of players
        players = new address payable[](0); 



    }

}
