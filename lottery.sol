pragma solidity ^0.5.0;

contract Lottery {

    struct EntryInfo {
        uint8 entryNumber;
        bool entried;
    }

    // TODO: add state

    mapping (address => EntryInfo) entryInfos;
    address payable[] entryAddresses;
    address payable[] winAddresses;
    
    address admin;

    constructor() public {
        admin = msg.sender;
    }

    function getEntryCount() public view returns(uint) {
        return entryAddresses.length;
    }

    function getEntryAddresses() public view returns(address payable[] memory) {
        return entryAddresses;
    }

    function entry(uint8 entryNumber) public payable {
        EntryInfo storage entryInfo = entryInfos[msg.sender];
        if (entryInfo.entried) {
            return;
        }

        entryInfo.entried = true;
        entryInfo.entryNumber = entryNumber;
        entryAddresses.push(msg.sender);
    }

    function draw() public {
        require(entryAddresses.length > 0, "To draw the lottery, you need to entry");
        require(admin == msg.sender, "This function can be excuted by admin");

        uint winNumber = (uint(blockhash(block.number - 1)) % 2) + 1;

        for (uint i = 0; i < entryAddresses.length; i++) {
            EntryInfo storage entryInfo = entryInfos[entryAddresses[i]];
            if (entryInfo.entried && entryInfo.entryNumber == winNumber) {
                winAddresses.push(entryAddresses[i]);
            }
        }

        if (winAddresses.length > 0) {
            for (uint i = 0; i < winAddresses.length; i++) {
                winAddresses[i].transfer((address(this).balance) / winAddresses.length);
            }
        }

        for (uint i = 0; i < entryAddresses.length; i++) {
            delete entryInfos[entryAddresses[i]];
        }
        
        delete entryAddresses;
        delete winAddresses;
    }

    function getEntryInfo(address account) public view returns(uint8, bool) {
        EntryInfo memory entryInfo = entryInfos[account];
        return (entryInfo.entryNumber, entryInfo.entried);
    }

}