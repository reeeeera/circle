# Circle

Social groups with encrypted messages and private circles

## Why this exists

Privacy matters. Most apps claim to protect your data, but when they need to process it, everything gets decrypted. That's not really privacy, is it?

This project uses Zama's fully homomorphic encryption to actually keep your data private - even while the system is working with it. The algorithms can run, calculations can happen, matches can be made - all without ever seeing your actual information.

## What you can do

- Keep your data encrypted on-chain
- Let the system process it without decrypting
- Only reveal what you want, when you want
- Trust that your privacy is actually protected

## Tech stuff

Built with:
- **Zama FHEVM** - The magic that makes this possible
- **Hardhat** - For smart contract development
- **Solidity 0.8.24** - Writing the contracts
- **TypeScript** - Because types are your friend

Contracts are on Sepolia testnet. You'll need some testnet ETH to play around.

## Quick start

`ash
npm install
npm run compile
`

Set up your .env (check env.template for what you need).

Deploy:

`ash
npm run deploy:sepolia
`

## Contracts

- `EventPlanner`
- `GroupManager`

Check contracts.json for deployed addresses.

## How it works

The data gets encrypted before it hits the blockchain. The smart contract can perform operations on it while it's still encrypted. Only when you explicitly allow it does anything get decrypted - and even then, only for the specific purpose you authorized.

## Contributing

This is a proof of concept. Feel free to fork it, break it, improve it. If you find bugs or have ideas, open an issue or send a PR.

## License

MIT


