// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.27;

import {Token} from "./Token.sol";

contract Factory {
    uint256 public immutable fee;
    address public owner;

    uint256 public totalTokens;
    address[] public tokens;

    mapping(address => TokenSale) public tokenToSale;

    event Created(address indexed token);

    struct TokenSale {
        address token;
        string name;
        address creator;
        uint256 sold;
        uint256 raised;
        bool isOpen;
    }

    constructor(uint256 _fee) {
        fee = _fee;
        owner = msg.sender;
    }

    function getTokenSale(
        uint256 _index
    ) public view returns (TokenSale memory) {
        return tokenToSale[tokens[_index]];
    }

    function create(
        string memory _name,
        string memory _symbol
    ) external payable {
        require(msg.value >= fee, "Factory: Creator fee not met");

        Token token = new Token(msg.sender, _name, _symbol, 1_000_000 ether);

        tokens.push(address(token));
        totalTokens++;

        //List token for sale
        // Create the sale.
        TokenSale memory sale = TokenSale(
            address(token),
            _name,
            msg.sender,
            0,
            0,
            true
        );
        // Save the sale to mapping.
        tokenToSale[address(token)] = sale;

		emit Created(address(token));
    }
}
