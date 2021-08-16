import { ethers } from "ethers";

export const provider = new ethers.providers.Web3Provider(window.ethereum);
