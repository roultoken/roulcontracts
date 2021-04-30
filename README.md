# Roul Token

Roul Token is a gambling dapp on the Binance Smart Chain. Holders of the BEP-20 "$ROUL" token are possibly eligible for three separate lotteries. The lotteries pay out every 4 hours, every day, and every week.

The eligibility for the lotteries are:

- Users must hold at least 1000 $ROUL to be eligible for the 4 hour lottery.

- Of all users with at least 1000 $ROUL, a user is eligible for the daily lottery if they are in the top 60% of those users.

- Of all users with at least 2000 $ROUL, a user is eligible for the weekly lottery if they are in the top 15% of those users.

10% of each transfer of $ROUL tokens (which includes buying/selling from PancakeSwap) is taken for:

- 1% burned
- 5% for lotteries
- 1% for adding liquidity to PancakeSwap
- 3% for the team

The 4 hour lottery pays out from 2.5% of the transfer fees.
The daily lottery pays out from 1.5% of the transfer fees.
The weekly lottery pays out from 1.0% of the transfer fees.

The core of RoulToken consists of four contracts.


## The Token Contract

The token contract is based on the ERC-20 standard, and has some added features:

- Ability to set two separate lottery contracts that will receive 2.5% of transfer fees each.

- Overrides the `function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override` function to take the various fees, as well as call a function on each lottery contract `function addressBalancesUpdated(
        address user1,
        uint256 balance1,
        address user2,
        uint256 balance2) external;` so the lottery contracts can keep track of the user's balances.

The second lottery contract, `LotteryTaxCollector` was temporary set to just collect fees, but due to an error in the token contract, it cannot be changed to another contract anymore. The plan is to transfer the ownership of `LotteryTaxCollector` to `LotteryManager` so that it can handle paying out the 4 hour lottery with the funds the tax collector gets.

The first lottery contract is currently deployed, and handles just the 4 hour lottery at this time. 

We are updating that contract to be the `LotteryManager` contract which will handle all three lotteries going forward.

## The Tax Collector Contract

This contract collects 2.5% of the transfer fees from the token contract, and just holds them. The lottery manager contract will become the owner and be able to distribute the funds to the winner of the 4 hour lottery.

## The Balance Tracker

This contract handles keeping track of every user's balance (minimum 1 $ROUL) in an "Order Statistics Tree", so that it is possible to efficiently query for a random user over a certain balance, as well as a user in the top % over a certain balance.

It uses the Solidity library found here:

https://github.com/rob-Hitchens/OrderStatisticsTree

## The Lottery Manager

This contract handles collecting fees, and generating the winner of the three lotteries. It receiving 2.5% of the transfer fees, to be paid out to the daily and weekly lotteries, and also is the owner of the 4 hour lottery tax collector so it can payout for that lottery as well.

When this contract's function `addressBalancesUpdated` is called, it will call the function in the balance tracker, `function updateUserBalance(address user) external` for both of the users, to keep their balances up to date in the balance tracker's tree.

It uses the balance tracker contract to efficiently query for a random user that matches the criteria for the lottery it is completing. 

### Contracts

- $ROUL Token: https://www.bscscan.com/address/0x712661a1976992a8f8c82FE74ba4E81a82De1F32#code
- Tax Collector: https://www.bscscan.com/address/0x458d3cac76e8bd77c322ef800e3969bb10813d55#code

See the source files in this repository for the `LotteryManager` and `BalanceManager` contracts.

