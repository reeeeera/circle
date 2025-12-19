// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";
import {FHE} from "@fhevm/solidity/lib/FHE.sol";
import {euint32} from "@fhevm/solidity/lib/FHE.sol";

// private events and meetings
contract EventPlanner is ZamaEthereumConfig {
    struct Event {
        uint256 groupId;
        address organizer;
        string title;
        uint256 eventTime;
        euint32 attendeeCount;  // encrypted
        address[] attendees;
    }
    
    mapping(uint256 => Event) public events;
    mapping(uint256 => mapping(address => bool)) public rsvps;
    uint256 public eventCounter;
    
    event EventCreated(uint256 indexed eventId, uint256 groupId);
    event RSVPReceived(uint256 indexed eventId, address attendee);
    
    function createEvent(
        uint256 groupId,
        string memory title,
        uint256 eventTime
    ) external returns (uint256 eventId) {
        eventId = eventCounter++;
        events[eventId] = Event({
            groupId: groupId,
            organizer: msg.sender,
            title: title,
            eventTime: eventTime,
            attendeeCount: FHE.asEuint32(0),
            attendees: new address[](0)
        });
        emit EventCreated(eventId, groupId);
    }
    
    function rsvp(uint256 eventId) external {
        Event storage event_ = events[eventId];
        require(!rsvps[eventId][msg.sender], "Already RSVP'd");
        
        rsvps[eventId][msg.sender] = true;
        event_.attendees.push(msg.sender);
        event_.attendeeCount = FHE.add(event_.attendeeCount, FHE.asEuint32(1));
        
        emit RSVPReceived(eventId, msg.sender);
    }
}

