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

const testFolder = path.join(__dirname, `../testTraces/paymentSplitter`);
// set up tests for contracts
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

// read setup.txt in each test folder
const transactionFolders = fs.readdirSync(testFolder, {withFileTypes: true})
  .filter(dirent => dirent.isDirectory())
  .map(dirent => dirent.name);
const transactionCounts = transactionFolders.length;
var transactionName;
var transactionFolderPath;
var setupPath;
var transactionCount = 1;
var tracefileCount = 0;

helper.range(transactionCounts).forEach(l => {
  transactionName = transactionFolders[l];
  transactionFolderPath = path.join(testFolder, `/${transactionName}`);
  setupPath = path.join(transactionFolderPath, '/setup.txt');
  if (fs.existsSync(setupPath)) {
    console.log('setup exists');
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

  if(transactionName == 'release') {
    // release: two-phase setup — constructor() has no args, then addPayee per payee, finalizeSetup, then release
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let deployer = helper.random(0, deployAccountCount);
      let numPayees = helper.random(3, 6); // 3 to 5 payees
      let payees = [];
      while(payees.length < numPayees) {
        let v = helper.random(0, deployAccountCount);
        if(!payees.includes(v) && v != deployer) payees.push(v);
      }
      // random shares per payee
      let shares = [];
      for(let k = 0; k < numPayees; k++) {
        shares.push(helper.random(10, 51));
      }
      // constructor with no args
      let text = `release,constructor,,,${deployer},,false\n`;
      // addPayee for each payee (called by deployer/owner)
      payees.forEach((p, idx) => {
        text += `release,addPayee,instance,accounts[${p}] ${shares[idx]},${deployer},,false\n`;
      });
      // finalizeSetup to lock the payee list
      text += `release,finalizeSetup,instance,,${deployer},,false\n`;
      // release for each payee - all marked true
      payees.forEach(p => {
        text += `release,release,instance,accounts[${p}],${deployer},,true\n`;
      });
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        console.log('generating new tracefiles ...');
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text, function (err) {
          if (err) throw err;
          console.log('File is created successfully.');
        });
      }
    })
  }

})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
