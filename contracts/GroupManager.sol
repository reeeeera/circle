// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ZamaEthereumConfig} from "@fhevm/solidity/config/ZamaConfig.sol";
import {euint32} from "@fhevm/solidity/lib/FHE.sol";

// private groups with encrypted membership
contract GroupManager is ZamaEthereumConfig {
    struct Group {
        address creator;
        string name;
        address[] members;
        mapping(address => bool) isMember;
        mapping(address => string) roles;  // "admin", "member", etc
    }
    
    struct GroupMessage {
        address sender;
        euint32 content;
        uint256 timestamp;
    }
    
    mapping(uint256 => Group) public groups;
    mapping(uint256 => GroupMessage[]) public messages;
    uint256 public groupCounter;
    
    event GroupCreated(uint256 indexed groupId, address creator);
    event MemberAdded(uint256 indexed groupId, address member);
    event MessageSent(uint256 indexed groupId, address sender);
    
    function createGroup(string memory name) external returns (uint256 groupId) {
        groupId = groupCounter++;
        Group storage group = groups[groupId];
        group.creator = msg.sender;
        group.name = name;
        group.members.push(msg.sender);
        group.isMember[msg.sender] = true;
        group.roles[msg.sender] = "admin";
        
        emit GroupCreated(groupId, msg.sender);
    }
    
    function addMember(uint256 groupId, address member) external {
        Group storage group = groups[groupId];
        require(group.isMember[msg.sender], "Not a member");
        require(keccak256(abi.encodePacked(group.roles[msg.sender])) == keccak256(abi.encodePacked("admin")) || msg.sender == group.creator, "Not authorized");
        require(!group.isMember[member], "Already a member");
        
        group.members.push(member);
        group.isMember[member] = true;
        group.roles[member] = "member";
        
        emit MemberAdded(groupId, member);
    }
    
    function sendMessage(uint256 groupId, euint32 encryptedContent) external {
        Group storage group = groups[groupId];
        require(group.isMember[msg.sender], "Not a member");
        
        messages[groupId].push(GroupMessage({
            sender: msg.sender,
            content: encryptedContent,
            timestamp: block.timestamp
        }));
        
        emit MessageSent(groupId, msg.sender);
    }
}

