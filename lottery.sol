pragma solidity ^0.5.0;

contract LotteryContract {

    struct EntryInfo {
        uint8 entryNumber;
        bool entried;
    }

    // TODO: add state

    mapping (address => EntryInfo) entryInfos;
    address payable[] entryAddresses;
    address payable[] winAddresses;
    uint32 entryCount;
    
    address admin;


    constructor() public {
        admin = msg.sender;
        entryCount = 0;
    }

    function getEntryCount() public view returns(uint32) {
        return entryCount;
    }

    function entry(uint8 entryNumber) public {
        EntryInfo storage entryInfo = entryInfos[msg.sender];
        if (entryInfo.entried) {
            return;
        }

        entryInfo.entried = true;
        entryInfo.entryNumber = entryNumber;
        entryAddresses.push(msg.sender);
        entryCount++;
    }

    function draw() payable public {
        if (admin != msg.sender) {
            return;
        }

        uint winNumber = (uint(blockhash(block.number - 1)) % 10) + 1;

        for (uint i = 0; i < entryAddresses.length; i++) {
            EntryInfo memory entryInfo = entryInfos[entryAddresses[i]];
            if (entryInfo.entried && entryInfo.entryNumber == winNumber) {
                winAddresses.push(entryAddresses[i]);
            }
        }


        if (winAddresses.length > 0) {
            uint256 dividend = entryCount / winAddresses.length;
            for (uint i = 0; i < winAddresses.length; i++) {
                winAddresses[i].transfer(dividend);
            }
        }

        // selfdestruct(contractOwner);
    }
}