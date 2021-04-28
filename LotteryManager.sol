
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}



library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     *
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     *
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     *
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     *
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}


interface IERC20 {

    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [// importANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies in extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        // solhint-disable-next-line no-inline-assembly
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * // importANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain`call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}



contract ERC20 is Context, IERC20 {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;


    constructor (string memory name, string memory symbol) {
        _name = name;
        _symbol = symbol;
        _decimals = 6;
    }

    function name() public view returns (string memory) {
        return _name;
    }


    function symbol() public view returns (string memory) {
        return _symbol;
    }


    function decimals() public view returns (uint8) {
        return _decimals;
    }


    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return _balances[account];
    }


    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }


    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }


    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }


    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }


    function _transfer(address sender, address recipient, uint256 amount) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }


    function _mint(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");

        _beforeTokenTransfer(address(0), account, amount);

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }


    function _burn(address account, uint256 amount) internal virtual {
        require(account != address(0), "ERC20: burn from the zero address");

        _beforeTokenTransfer(account, address(0), amount);

        _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
        _totalSupply = _totalSupply.sub(amount);
        emit Transfer(account, address(0), amount);
    }


    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _setupDecimals(uint8 decimals_) internal {
        _decimals = decimals_;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
}




interface LotteryTaxCollector {
    function withdraw(address _to) external;

    function transferOwnership(address newOwner) external;
}

interface BalanceTracker {

    function updateUserBalance(
        address user) external;

    function getUserAtRank(
        uint256 rank) external view returns (address);

    function getRankForUser(
        address user) external view returns (uint256);

    function getRandomUserMinimumTokenBalance(
        uint256 blockNumber,
        uint256 minimumTokenBalance) external view returns (address);

    function getRandomUserTopPercent(
        uint256 blockNumber,
        uint256 percent,
        uint256 minimumTokenBalance) external view returns (address);

    function getRandomUserTop(
        uint256 blockNumber,
        uint256 top) external view returns (address);


    function makeSenderIneligible() external;

    function treeBelow(
        uint256 value) external view returns (uint256);

    function treeAbove(
        uint256 value) external view returns (uint256);

    function treeCount() external view returns (uint256);
 
    function treeValueAtRank(uint256 rank) external view returns (uint256); 
}





pragma solidity 0.7.3;

// SPDX-License-Identifier: Unlicensed

contract LotteryManager is Ownable {

    using SafeMath for uint256;

    //Hardcode in address of the $ROUL token
    ERC20 public roulToken = ERC20(0x712661a1976992a8f8c82FE74ba4E81a82De1F32);

    //Hardcode in address of the balance tracker
    BalanceTracker public balanceTracker = BalanceTracker(0x2Bf4d09D0Ee7F43f2aAbDb906A51f337b82bF6d5);

    //The taxCollector is getting 2.5% transfer fees from the roulToken.
    //This contract can withdraw the funds to the winner from the taxCollector for each 4 hour lottery.
    LotteryTaxCollector public taxCollector = LotteryTaxCollector(0x458d3cac76e8bd77c322ef800e3969bb10813d55);


    struct Lottery {
        //How long the lottery lasts
        uint256 secondsPerLottery;
        //How many seconds before UTC the first/only lottery of the day starts
        uint256 startTimeOffset;
        //If non-zero, the top percent of users who are eligible
        uint256 topHoldersPercent;
        //If topHoldersPercent is non-zero, then a random user
        //in the top percent of users with at least this many
        //tokens will be chosen. If it's zero, it's a random
        //user out of all users with at least this amount. 
        uint256 minimumTokenBalance;
        //Keep track of which lotteries have been completed
        mapping(uint256 => bool) completedLotteries;
        //Name of the lottery for events
        string name;
        //Percent of tokens earned the lottery gets,
        //of all tokens this contract takes as fees,
        //which is 2.5% on all transfers
        uint256 payoutPercent;
        //If the lottery uses the tax collector contract, which takes 2.5% fees, to pay out
        bool payoutUsesTaxCollector;
        //Keep track of how many tokens the lottery has accumulated to payout
        uint256 currentPot;
    }

    Lottery[] public lotteries;
    
    //Keep track of last tokens balance, so that when new tokens are
    //received as fees, the "currentPot" of the lotteries can be updated
    //based on their payoutPercent
    uint256 private lastTokenBalance;

    //Emit events when someone wins the lottery
    //Index is their index in the array when they won
    //Lottery number is floor((<block time for first block of lottery> + <offset>) / secondsPerLottery)
    event LotteryWon(string indexed name, address indexed user, uint256 tokens, uint256 lotteryNumber);

    //Emitted when a lottery's top holders percent is updated
    event LotteryTopHoldersPercentUpdated(string indexed name, uint256 newValue, uint256 oldValue);

    //Emitted when a lottery's minimum tokens is updated
    event LotteryMinimumTokenBalanceUpdated(string indexed name, uint256 newValue, uint256 oldValue);

    event LotteryCurrentPotUpdated(string indexed name, uint256 newValue, uint256 oldValue);

    constructor() {

        Lottery storage fourHourLottery = lotteries.push();

        fourHourLottery.secondsPerLottery = 14400;
        fourHourLottery.startTimeOffset = 0;
        fourHourLottery.topHoldersPercent = 0;
        fourHourLottery.minimumTokenBalance = 1000 * (10 ** roulToken.decimals());
        fourHourLottery.name = "Four Hour";
        fourHourLottery.payoutPercent = 0; //Takes fromt tax collector
        fourHourLottery.payoutUsesTaxCollector = true;

        Lottery storage dailyLottery = lotteries.push();

        dailyLottery.secondsPerLottery = 86400;
        //Start time is 22:00 so offset by 2 hours backwards
        dailyLottery.startTimeOffset = 7200;
        dailyLottery.topHoldersPercent = 60;
        dailyLottery.minimumTokenBalance = 1000 * (10 ** roulToken.decimals());
        dailyLottery.name = "Daily";
        dailyLottery.payoutPercent = 60; //1.5% overall
        dailyLottery.payoutUsesTaxCollector = false;

        Lottery storage weeklyLottery = lotteries.push();

        weeklyLottery.secondsPerLottery = 604800;
        //Start time is 14:00 on Sunday, which is 3 full days and
        //10 hours before the week cutoff, which is at Thursday 00:00.
        weeklyLottery.startTimeOffset = 295200;
        weeklyLottery.topHoldersPercent = 15;
        weeklyLottery.minimumTokenBalance = 2000 * (10 ** roulToken.decimals());
        weeklyLottery.name = "Weekly";
        weeklyLottery.payoutPercent = 40; //1.0% overall
        weeklyLottery.payoutUsesTaxCollector = false;


        //Don't allow the previous lotteries to be completed,
        //because they existed before this contract was deployed
        for(uint256 i = 0; i < lotteries.length; i++) {
            Lottery storage lottery = lotteries[i];
            lottery.completedLotteries[getCurrentLotteryNumber(i).sub(1)] = true;
        }

        //Make this lottery not eligible for tracking
        balanceTracker.makeSenderIneligible();
    }

   
    //Allows owner to update the top holders percent
    //of a lottery
    function updateLotteryTopHoldersPercent(
        uint256 lotteryIndex,
        uint256 topHoldersPercent
    )
        onlyOwner
        external {
        require(topHoldersPercent >= 0 && topHoldersPercent <= 100);
        Lottery storage lottery = lotteries[lotteryIndex];

        uint256 oldValue = lottery.topHoldersPercent;
        lottery.topHoldersPercent = topHoldersPercent;

        emit LotteryTopHoldersPercentUpdated(lottery.name, topHoldersPercent, oldValue);
    }

     //Allows owner to update the minimum tokens
    //of a lottery
    function updateLotteryMinimumTokenBalance(
        uint256 lotteryIndex,
        uint256 minimumTokenBalance
    )
        onlyOwner
        external {
        Lottery storage lottery = lotteries[lotteryIndex];

        uint256 oldValue = lottery.minimumTokenBalance;
        lottery.minimumTokenBalance = minimumTokenBalance;

        emit LotteryMinimumTokenBalanceUpdated(lottery.name, minimumTokenBalance, oldValue);
    }

    //Gives this contract the ability to 
    //transfer the ownership of the taxCollector
    //to a new owner
    function transferTaxCollectorOwnership(
        address newOwner
    )
        onlyOwner
        external {
        taxCollector.transferOwnership(newOwner);
    }

    //Return the following data for the lottery at index:
    //-currentPot - how many tokens is in the lottery's pot
    //-secondsRemaining - how many seconds until it is over
    //-minimumTokenBalance - the current minimum token balance needed to
    //be eligible
    function getLotteryInfo(
        uint256 index)
        public view returns (uint256[] memory result) {
        result = new uint256[](3);

        Lottery storage lottery = lotteries[index];

        result[0] = lottery.currentPot;

        uint256 lotteryNumber = getCurrentLotteryNumber(block.timestamp);

        uint256 startTime = lotteryNumber.mul(lottery.secondsPerLottery).sub(lottery.startTimeOffset);

        uint256 endTime = startTime.add(lottery.secondsPerLottery);

        result[1] = endTime.sub(block.timestamp);

        //Get number of players with at least minimumTokenBalance
        uint256 eligibleHolders = balanceTracker.treeAbove(lottery.minimumTokenBalance);
        //Take the topHoldersPercent of the number of holders
        eligibleHolders = eligibleHolders.mul(lottery.topHoldersPercent).div(100);

        if(eligibleHolders > 0) {
            //Get rank that is barely eligible
            uint256 rank = balanceTracker.treeCount().sub(eligibleHolders).add(1);
            //Get the value at the rank
            result[2] = balanceTracker.treeValueAtRank(rank);
        }
        else {   
            //No holders, so you'd need the minimumTokenBalance to be eligible
            result[2] = lottery.minimumTokenBalance;
        }
    }

    //Return data for all lotteries
    function getLotteriesInfo() public view returns (uint256[] memory result) {
        result = new uint256[](lotteries.length.mul(3));

        for(uint256 i = 0; i < lotteries.length; i = i.add(1)) {
            uint256[] memory lotteryResult = getLotteryInfo(i);

            for(uint256 j = 0; j < 3; j = j.add(1)) {
                result[i.mul(3).add(j)] = lotteryResult[j];
            }
        }
    }

    //Returns the user's position, as well as the total eligible players
    //for each lottery.
    //If the user's position is <= the number of eligible holders for a 
    //lottery, it means they are currently eligible.
    function getLotteryPosition(
        address user
    ) public view returns (uint256[] memory result) {
        result = new uint256[](lotteries.length.add(1));

        //Get the user's position in ascending order
        uint256 position = balanceTracker.getRankForUser(user);

        //If user has no tokens, don't return any data
        if(position != 0) {
            //Get total number of holders
            uint256 totalHolders = balanceTracker.treeCount();

            //Calculate the user's position in descending order
            position = totalHolders.sub(position).add(1);

            result[0] = position;

            for(uint256 i = 0; i < lotteries.length; i = i.add(1)) {
                Lottery storage lottery = lotteries[i];

                //Get number of players with at least minimumTokenBalance
                uint256 eligibleHolders = balanceTracker.treeAbove(lottery.minimumTokenBalance);
                //Take the topHoldersPercent of the number of holders
                eligibleHolders = eligibleHolders.mul(lottery.topHoldersPercent).div(100);

                result[i.add(1)] = eligibleHolders;
            }
        }
    }

    //Called by token contract so lottery can keep track of who owns tokens
    //Pass both balances that updated during a transfer to save on gas
    function addressBalancesUpdated(
        address user1,
        uint256,
        address user2,
        uint256
    ) 
        external {
        //Must be called by the roulToken
        require(msg.sender == address(roulToken));

        //Complete any previous lottery if needed beforehand,
        //so that if a lottery should be completed, no future balance changes
        //can occur before it is paid out.
        completeAnyPreviousLotteryIfNeeded();

        //Update both user balances
        updateUserBalance(user1);
        updateUserBalance(user2);

        uint256 balanceNow = roulToken.balanceOf(address(this));

        //For new money received, distribute to
        //the lotteries
        if(balanceNow > lastTokenBalance) {
            //Keep track of excess
            uint256 excess = balanceNow.sub(lastTokenBalance);
            //Keep track of percent that has not been accounted for
            uint256 percentLeft = 100;

            //Iterate through all lotteries
            for(uint256 i = 0; i < lotteries.length; i++) {
                Lottery storage lottery = lotteries[i];

                //If the lottery has a payout percent
                if(lottery.payoutPercent > 0) {
                    //The number of tokens is remaining in excess multiplied
                    //by a factor of what percent is left
                    uint256 tokens = excess.mul(lottery.payoutPercent).div(percentLeft);

                    //Should not happen if the percents add to 100 exactly
                    if(tokens > excess) {
                        tokens = excess;
                    }

                    uint256 oldValue = lottery.currentPot;

                    lottery.currentPot = lottery.currentPot.add(tokens);
                    excess = excess.sub(tokens);

                    percentLeft = percentLeft.sub(lottery.payoutPercent);

                    emit LotteryCurrentPotUpdated(lottery.name, lottery.currentPot, oldValue);
                }
            }

            lastTokenBalance = roulToken.balanceOf(address(this));
        }
    }

        //Use try so that the transaction doesn't complete fail if the balanceTracker
        //reverts
    function updateUserBalance(
        address user) public returns (bool) {
        if(user != address(0x0)) {
            try balanceTracker.updateUserBalance(user) {
                return true;
            }
            catch(bytes memory) {
                return false;
            } 
        }
    }

    //The current lottery number is equal to floor(current block's timestamp / secondsPerLottery)
    function getCurrentLotteryNumber(uint256 lotteryIndex)
        internal view returns (uint256) {
        return getLotteryNumberForTimestamp(lotteryIndex, block.timestamp);
    }

    function getLotteryNumberForTimestamp(
        uint256 lotteryIndex,
        uint256 timestamp) internal view returns (uint256) {
        Lottery storage lottery = lotteries[lotteryIndex];
        //Subtract the offset to find the lottery number
        //Since the offset is negative, the lottery starts earlier,
        //so by subtracting a negative number, the lottery number will increase
        //earlier than normal
        return timestamp.add(lottery.startTimeOffset).div(lottery.secondsPerLottery);
    }

    //Anyone can call this
    function completeAnyPreviousLotteryIfNeeded() 
        public {
        for(uint256 i = 0; i < lotteries.length; i = i.add(1)) {
            completePreviousLotteryIfNeeded(i);
        }
    }

    //Anyone can call this
    function completePreviousLotteryIfNeeded(uint256 lotteryIndex) 
        public {
        Lottery storage lottery = lotteries[lotteryIndex];

        //The lottery number for a given time is floor((time + dailyLotteryStartTimeOffset) / dailyLotterySecondsPerLottery)
        //and this will get the lottery number for the current time
        uint256 currentLotteryNumber = getCurrentLotteryNumber(lotteryIndex);
        uint256 previousLotteryNumber = currentLotteryNumber.sub(1);

        //Make sure the lottery is not completed
        if(lottery.completedLotteries[previousLotteryNumber]) {
            return;
        }

        //Get the time of the block that started the lottery
        uint256 lotteryTime = (currentLotteryNumber * lottery.secondsPerLottery).sub(lottery.startTimeOffset);
        //Get the number of blocks that have elapsed since the start of the lottery, assuming 3 second block times
        //lotteryTime will be <= currentBlockTime
        uint256 blocksElapsed = (block.timestamp.sub(lotteryTime)).div(3);
        //Get the block number at the start of the current lottery
        uint256 currentLotteryBlockNumber = block.number.sub(blocksElapsed);
        //Get the last block number in the previous lottery
        uint256 previousLotteryLastBlockNumber = currentLotteryBlockNumber.sub(1);

        //Find a random in top percent of users meeting minimum balance
        address winner = balanceTracker.getRandomUserTopPercent(
            previousLotteryLastBlockNumber,
            lottery.topHoldersPercent,
            lottery.minimumTokenBalance);

        if(winner != address(0x0)) {
            //Complete first so no re-entrancy to this part
            lottery.completedLotteries[previousLotteryNumber] = true;

            //The winner gets the tokens in the current pot
            uint256 winnings = lottery.currentPot;

            uint256 tokenBalance = roulToken.balanceOf(address(this));

            //Should not happen
            if(winnings > tokenBalance) {
                winnings = tokenBalance;
            }

            lottery.currentPot = 0;

            roulToken.transfer(winner, winnings);

            //Update this so next time fees are token,
            //they are added properly to the lotteries
            lastTokenBalance = roulToken.balanceOf(address(this));

            emit LotteryWon(lottery.name, winner, winnings, previousLotteryNumber);
        }
    }
}
