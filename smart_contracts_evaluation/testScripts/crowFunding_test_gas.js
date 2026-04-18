const {
  BN,
  constants,
  expectEvent,
  expectRevert,
  time,
} = require('@openzeppelin/test-helpers');

const helper = require("./helper_functions");
const fs = require('fs');
const path = require('path');

const testFolder = path.join(__dirname, `../testTraces/crowFunding`);
const testPath = path.join(testFolder, '/setup.txt');
const setup = fs.readFileSync(testPath, 'utf-8');
let contractName;
let deployAccountCount = 10;
setup.split(/\r?\n/).some(line => {
  let lineArr = line.split(',');
  if(lineArr[0] == 'n') {
    contractName = lineArr[1];
    return true;
  }
  if(lineArr[0] == 'a') {
    deployAccountCount = +lineArr[1];
  }
})

// Only invest and close are measured. refund / withdraw are skipped:
// the reference contract (crowFundingref.sol) delegates those to an inner
// Escrow contract, so `instance.refund` / `instance.withdraw` are undefined
// on the outer CrowFunding wrapper and no single trace can drive both the
// generated variants and the reference.
const measuredTransactions = new Set(['invest', 'close']);
const transactionFolders = fs.readdirSync(testFolder, {withFileTypes: true})
  .filter(dirent => dirent.isDirectory())
  .map(dirent => dirent.name)
  .filter(name => measuredTransactions.has(name));
const transactionCounts = transactionFolders.length;
var transactionName;
var transactionFolderPath;
var setupPath;
var transactionCount = 1;
var tracefileCount = 0;

// Large future timestamp used as closeTime so invest's `block.timestamp <= closeTime`
// check always passes during tests (year ~2286). The .dl constructor takes ct
// explicitly because Datalog cannot compute `now() + 30 days` at construction time.
const FAR_FUTURE_CLOSE_TIME = 9999999999;

helper.range(transactionCounts).forEach(l => {
  transactionName = transactionFolders[l];
  transactionFolderPath = path.join(testFolder, `/${transactionName}`);
  setupPath = path.join(transactionFolderPath, '/setup.txt');
  if (fs.existsSync(setupPath)) {
    const setupFS = fs.readFileSync(setupPath, 'utf-8');
    const setupLines = setupFS.split(/\r?\n/);
    let i = 0;
    while(i < setupLines.length) {
      let sl = setupLines[i];
      if(sl.startsWith('nt')) {
        transactionCount = +sl.split(',')[1];
      }
      i++;
    }
  }

  // Constructor: (uint target, address beneficiary, uint closeTime).
  // owner = deployer, raised = 0, closed = false.

  if(transactionName == 'invest') {
    // payable, closed == false, block.timestamp <= closeTime, raised < target
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let beneficiary;
      do { beneficiary = helper.random(0, deployAccountCount); } while(beneficiary == deployer);
      let sender;
      do { sender = helper.random(0, deployAccountCount); } while(sender == deployer || sender == beneficiary);
      let target = 100000;
      let val1 = helper.random(100, 5001);
      let val2 = helper.random(100, 5001);
      let text = `invest,constructor,,${target} accounts[${beneficiary}] ${FAR_FUTURE_CLOSE_TIME},${deployer},,false\n`;
      text += `invest,invest,instance,,${sender},${val1},false\n`;
      text += `invest,invest,instance,,${sender},${val2},true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'close') {
    // close succeeds via the `raised >= target` rule branch, which avoids any
    // time manipulation: deploy with a small target and a far-future closeTime,
    // have one investor fund exactly `target` so raised == target, then close.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let beneficiary;
      do { beneficiary = helper.random(0, deployAccountCount); } while(beneficiary == deployer);
      let investor;
      do { investor = helper.random(0, deployAccountCount); } while(investor == deployer || investor == beneficiary);
      let target = 10000;
      let text = `close,constructor,,${target} accounts[${beneficiary}] ${FAR_FUTURE_CLOSE_TIME},${deployer},,false\n`;
      text += `close,invest,instance,,${investor},${target},,false\n`;
      text += `close,close,instance,,${deployer},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
