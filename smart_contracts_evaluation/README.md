## Set up environment
```
npm install
```
Then run
```
ganache -a 10 -p 8545 --logging.debug
```
## To run experiment for a single contract
Open a new terminal window at current folder and run
```
./test.sh <name_of_the_contract>
```
For example, to run experiment for auction
```
./test.sh auction
```

## To run experiments for all contracts
Open a new terminal window at current folder and run
```
./all_experiments.sh
```

## Results
Results will be written to `./tracefiles_long/<contract_name>/<function_name>`. files starts with `opcode` in their names contain results for different versions of benchmarks. 

For example, within folder `./tracefiles_long/auction/bid`
- `opcode_min_1.txt` is the test result for `contracts/auction/auction1.sol` (one of the optimized versions).
- `opcode_min_2.txt` is the test result for `contracts/auction/auction2.sol` (one of the optimized versions).
- `opcode_full.txt` is the test result for `contracts/auction/auctionfull.sol` (Incr. Datalog).
- `opcode_ref.txt` is the test result for `contracts/auction/auctionref.sol` (reference).