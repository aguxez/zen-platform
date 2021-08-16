import { ethers } from "ethers";
import { CoreABI } from "../static/abis/Core.js";

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

        const provider =
          window.provider || new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const core = new ethers.Contract(
          "0x6fda6ef4c152ba700b080f2a299b3a8a8e659312",
          CoreABI,
          signer
        );
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
};
