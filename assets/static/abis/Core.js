export const CoreABI = [
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "_tradeId",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "address",
        name: "_owner",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "_tokenId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "_cell",
        type: "uint256",
      },
    ],
    name: "TokenAddedToTrade",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "_tradeId",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "address",
        name: "_owner",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "_tokenId",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "_cell",
        type: "uint256",
      },
    ],
    name: "TokenRemovedFromTrade",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "_tradeId",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "address",
        name: "_owner",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "_tokenId",
        type: "uint256",
      },
    ],
    name: "TradeExtended",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "bytes32",
        name: "_tradeId",
        type: "bytes32",
      },
    ],
    name: "TradeFinalized",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "_tradeId",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "address",
        name: "_starter",
        type: "address",
      },
      {
        indexed: false,
        internalType: "address",
        name: "_receiver",
        type: "address",
      },
      {
        indexed: false,
        internalType: "contract IERC721",
        name: "_starterContract",
        type: "address",
      },
      {
        indexed: false,
        internalType: "contract IERC721",
        name: "_receiverContract",
        type: "address",
      },
    ],
    name: "TradeStarted",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: true,
        internalType: "bytes32",
        name: "_tradeId",
        type: "bytes32",
      },
      {
        indexed: false,
        internalType: "address",
        name: "_user",
        type: "address",
      },
      {
        indexed: false,
        internalType: "bool",
        name: "_isReady",
        type: "bool",
      },
    ],
    name: "UserTradeStateChange",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "_tradeId",
        type: "bytes32",
      },
      {
        internalType: "uint256",
        name: "_tokenId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_cell",
        type: "uint256",
      },
    ],
    name: "addTokenToTrade",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "_tradeId",
        type: "bytes32",
      },
      {
        internalType: "bool",
        name: "_state",
        type: "bool",
      },
    ],
    name: "changeUserReadiness",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "_tradeId",
        type: "bytes32",
      },
    ],
    name: "getTrade",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "contract IERC721",
        name: "",
        type: "address",
      },
      {
        internalType: "contract IERC721",
        name: "",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "enum Core.TradeState",
        name: "",
        type: "uint8",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "address",
        name: "",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
      {
        internalType: "bytes",
        name: "",
        type: "bytes",
      },
    ],
    name: "onERC721Received",
    outputs: [
      {
        internalType: "bytes4",
        name: "",
        type: "bytes4",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "_tradeId",
        type: "bytes32",
      },
      {
        internalType: "uint256",
        name: "_cell",
        type: "uint256",
      },
    ],
    name: "removeTokenFromTrade",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "bytes32",
        name: "_tradeId",
        type: "bytes32",
      },
      {
        internalType: "address",
        name: "_starter",
        type: "address",
      },
      {
        internalType: "address",
        name: "_receiver",
        type: "address",
      },
      {
        internalType: "contract IERC721",
        name: "_starterContractAddress",
        type: "address",
      },
      {
        internalType: "contract IERC721",
        name: "_receiverContractAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_amountOfCells",
        type: "uint256",
      },
    ],
    name: "startTrade",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
];
