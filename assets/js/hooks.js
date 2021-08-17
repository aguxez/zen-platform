import { ethers } from "ethers";
import { CoreABI } from "../static/abis/Core.js";
import { IERC721ABI } from "../static/abis/IERC721.js";

export const Hooks = {
  ConnectWeb3: {
    mounted() {
      this.el.addEventListener("click", () => {
        const provider = new ethers.providers.Web3Provider(window.ethereum);

        provider.send("eth_requestAccounts", []);

        window.provider = provider;
      });
    },
  },
  CopyTradeLink: {
    mounted() {
      this.el.addEventListener("click", () => {
        let copyText = document.querySelector("#trade-confirm-link");
        copyText.select();
        document.execCommand("copy");
      });
    },
  },
  LoadContractInstance: {
    mounted() {
      this.el.addEventListener("click", (e) => {
        e.preventDefault();

        const provider = getProvider(window.provider);
        const signer = provider.getSigner();
        const core = getCoreContract(signer);
        const receiverTokenAddress = document.getElementById(
          "receiver-token-address"
        ).value;

        this.pushEvent("trade_init_params", {});

        this.handleEvent("trade_init_params", (payload) => {
          signer.getAddress().then((receiver) => {
            core.startTrade(
              ethers.utils.formatBytes32String(payload.trade.id),
              payload.trade.starter,
              receiver,
              payload.trade.starter_token_address,
              receiverTokenAddress,
              payload.trade.number_of_cells
            );
          });
        });
      });
    },
  },
  StarterBoxOfferings: {
    tokenAddress() {
      return this.el.dataset.tokenaddress;
    },
    mounted() {
      const provider = getProvider(window.provider);
      const signer = provider.getSigner();
      const erc721 = getERC721Contract(this.tokenAddress(), signer);
      const core = getCoreContract(signer);

      erc721
        .isApprovedForAll(signer.getAddress(), core.address)
        .then((isApproved) => {
          if (!isApproved) {
            erc721.setApprovalForAll(core.address, true);
          }
        });
    },
  },
  AddTokenToTrade: {
    tradeId() {
      return this.el.dataset.tradeid;
    },
    tradeCell() {
      return this.el.dataset.tradecell;
    },
    mounted() {
      this.el.addEventListener("click", (e) => {
        e.preventDefault();

        const provider = getProvider(window.provider);
        const signer = provider.getSigner();
        const core = getCoreContract(signer);

        core
          .addTokenToTrade(
            ethers.utils.formatBytes32String(this.tradeId()),
            "3000",
            this.tradeCell()
          )
          .catch((e) => {
            console.log(e);
          });
      });
    },
  },
};

const getProvider = (windowProvider) => {
  if (windowProvider) {
    return windowProvider;
  } else {
    return new ethers.providers.Web3Provider(window.ethereum);
  }
};

const getCoreContract = (signer) => {
  return new ethers.Contract(
    "0x6fda6ef4c152ba700b080f2a299b3a8a8e659312",
    CoreABI,
    signer
  );
};

const getERC721Contract = (address, signer) => {
  return new ethers.Contract(address, IERC721ABI, signer);
};
