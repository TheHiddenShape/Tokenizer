// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {RiddlerToken} from "../contracts/RiddlerToken.sol";

contract RiddlerTokenTest is Test {
    RiddlerToken public token;
    address public owner;
    address public addr1;
    address public addr2;
    
    uint256 constant INITIAL_SUPPLY = 1_000_000 ether;

    function setUp() public {
        owner = address(this);
        addr1 = address(0x1);
        addr2 = address(0x2);
        
        token = new RiddlerToken(INITIAL_SUPPLY);
    }

    // ===== DEPLOYMENT TESTS =====
    
    function testOwnerIsSet() public view {
        require(token.owner() == owner, "Owner not set correctly");
    }

    function testInitialSupply() public view {
        require(token.totalSupply() == INITIAL_SUPPLY, "Total supply incorrect");
        require(token.balanceOf(owner) == INITIAL_SUPPLY, "Owner balance incorrect");
    }

    function testTokenMetadata() public view {
        require(keccak256(bytes(token.name())) == keccak256(bytes("RiddlerToken")), "Name incorrect");
        require(keccak256(bytes(token.symbol())) == keccak256(bytes("RDLR")), "Symbol incorrect");
        require(token.decimals() == 18, "Decimals incorrect");
    }

    // ===== TRANSFER TESTS =====

    function testTransfer() public {
        uint256 amount = 100 ether;
        
        token.transfer(addr1, amount);
        
        require(token.balanceOf(addr1) == amount, "Addr1 balance incorrect");
        require(token.balanceOf(owner) == INITIAL_SUPPLY - amount, "Owner balance incorrect");
    }

    function testTransferFailsWithInsufficientBalance() public {
        vm.prank(addr1);
        vm.expectRevert();
        token.transfer(addr2, 1 ether);
    }

    // ===== APPROVAL TESTS =====

    function testApprove() public {
        uint256 amount = 100 ether;
        
        token.approve(addr1, amount);
        
        require(token.allowance(owner, addr1) == amount, "Allowance not set correctly");
    }

    function testTransferFrom() public {
        uint256 amount = 100 ether;
        
        token.approve(addr1, amount);
        
        vm.prank(addr1);
        token.transferFrom(owner, addr2, amount);
        
        require(token.balanceOf(addr2) == amount, "Addr2 balance incorrect");
        require(token.allowance(owner, addr1) == 0, "Allowance not consumed");
    }

    function testTransferFromFailsWithoutApproval() public {
        vm.prank(addr1);
        vm.expectRevert();
        token.transferFrom(owner, addr2, 100 ether);
    }

    // ===== MINTING TESTS =====

    function testMint() public {
        uint256 amount = 1000 ether;
        
        token.mint(addr1, amount);
        
        require(token.balanceOf(addr1) == amount, "Addr1 balance incorrect after mint");
        require(token.totalSupply() == INITIAL_SUPPLY + amount, "Total supply not increased");
    }

    function testMintFailsIfNotOwner() public {
        vm.prank(addr1);
        vm.expectRevert();
        token.mint(addr2, 1000 ether);
    }

    // ===== BURNING TESTS =====

    function testBurn() public {
        uint256 amount = 100 ether;
        
        token.burn(amount);
        
        require(token.balanceOf(owner) == INITIAL_SUPPLY - amount, "Owner balance incorrect after burn");
        require(token.totalSupply() == INITIAL_SUPPLY - amount, "Total supply not decreased");
    }

    function testBurnFrom() public {
        uint256 amount = 100 ether;
        
        token.approve(addr1, amount);
        
        vm.prank(addr1);
        token.burnFrom(owner, amount);
        
        require(token.balanceOf(owner) == INITIAL_SUPPLY - amount, "Owner balance incorrect after burnFrom");
        require(token.totalSupply() == INITIAL_SUPPLY - amount, "Total supply not decreased");
    }

    // ===== OWNERSHIP TESTS =====

    function testTransferOwnership() public {
        token.transferOwnership(addr1);
        
        require(token.owner() == addr1, "Ownership not transferred");
    }

    function testRenounceOwnership() public {
        token.renounceOwnership();
        
        require(token.owner() == address(0), "Ownership not renounced");
    }

    function testMintFailsAfterRenounce() public {
        token.renounceOwnership();
        
        vm.expectRevert();
        token.mint(addr1, 100 ether);
    }

    // ===== FUZZ TESTS =====

    function testFuzzTransfer(address to, uint256 amount) public {
        vm.assume(to != address(0));
        vm.assume(amount <= INITIAL_SUPPLY);
        
        token.transfer(to, amount);
        
        require(token.balanceOf(to) == amount, "Fuzz transfer failed");
    }

    function testFuzzMint(address to, uint256 amount) public {
        vm.assume(to != address(0));
        vm.assume(amount < type(uint256).max - INITIAL_SUPPLY);
        
        token.mint(to, amount);
        
        require(token.balanceOf(to) == amount, "Fuzz mint balance incorrect");
        require(token.totalSupply() == INITIAL_SUPPLY + amount, "Fuzz mint supply incorrect");
    }
}