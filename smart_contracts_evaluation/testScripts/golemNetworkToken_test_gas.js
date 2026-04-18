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

const testFolder = path.join(__dirname, `../testTraces/golemNetworkToken`);
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

const RATE = 1000;
const CAP = 820000000;
const MIN_SUPPLY = 150000000;
// create with v=150001 gives 150001000 tokens >= MIN_SUPPLY for finalize
const FINALIZE_CREATE_VALUE = 150001;

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

  // Constructor: accounts[factory] accounts[master] accounts[locked] 0 99999999999

  if(transactionName == 'create') {
    // create: payable, funding=true, v > 0, v <= (cap-ts)/r
    // Use v=1 (mints 1000 tokens per call)
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let factory = helper.random(0, deployAccountCount);
      let master, locked, sender;
      do { master = helper.random(0, deployAccountCount); } while(master == factory);
      do { locked = helper.random(0, deployAccountCount); } while(locked == factory || locked == master);
      do { sender = helper.random(0, deployAccountCount); } while(sender == factory || sender == master || sender == locked);
      let text = `create,constructor,,accounts[${factory}] accounts[${master}] accounts[${locked}] 0 99999999999,${factory},,false\n`;
      text += `create,create,instance,,${sender},1,,false\n`;
      text += `create,create,instance,,${sender},1,,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'finalize') {
    // finalize: funding=true, canFinalize (totalSupply >= min). One-shot.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let factory = helper.random(0, deployAccountCount);
      let master, locked, funder, caller;
      do { master = helper.random(0, deployAccountCount); } while(master == factory);
      do { locked = helper.random(0, deployAccountCount); } while(locked == factory || locked == master);
      do { funder = helper.random(0, deployAccountCount); } while(funder == factory || funder == master || funder == locked);
      caller = helper.random(0, deployAccountCount);
      let text = `finalize,constructor,,accounts[${factory}] accounts[${master}] accounts[${locked}] 0 99999999999,${factory},,false\n`;
      text += `finalize,create,instance,,${funder},${FINALIZE_CREATE_VALUE},,false\n`;
      text += `finalize,finalize,instance,,${caller},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'transfer') {
    // transfer: needs funding=false + balance. Setup: create + finalize.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let factory = helper.random(0, deployAccountCount);
      let master, locked, sender;
      do { master = helper.random(0, deployAccountCount); } while(master == factory);
      do { locked = helper.random(0, deployAccountCount); } while(locked == factory || locked == master);
      do { sender = helper.random(0, deployAccountCount); } while(sender == factory || sender == master || sender == locked);
      let arrayRandom = [];
      for (let index = 0; index < deployAccountCount; index++) {
        if(index != sender) arrayRandom.push(index);
      }
      let to = arrayRandom[helper.random(0, arrayRandom.length)];
      let amt1 = helper.random(1, 1001);
      let amt2 = helper.random(1, 1001);
      let text = `transfer,constructor,,accounts[${factory}] accounts[${master}] accounts[${locked}] 0 99999999999,${factory},,false\n`;
      text += `transfer,create,instance,,${sender},${FINALIZE_CREATE_VALUE},,false\n`;
      text += `transfer,finalize,instance,,${sender},,false\n`;
      text += `transfer,transfer,instance,accounts[${to}] ${amt1},${sender},,false\n`;
      text += `transfer,transfer,instance,accounts[${to}] ${amt2},${sender},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'setMigrationAgent') {
    // setMigrationAgent: funding=false, sender=master, agent=0. One-shot.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let factory = helper.random(0, deployAccountCount);
      let master, locked, funder, agent;
      do { master = helper.random(0, deployAccountCount); } while(master == factory);
      do { locked = helper.random(0, deployAccountCount); } while(locked == factory || locked == master);
      do { funder = helper.random(0, deployAccountCount); } while(funder == factory || funder == master || funder == locked);
      do { agent = helper.random(0, deployAccountCount); } while(agent == factory || agent == master || agent == locked);
      let text = `setMigrationAgent,constructor,,accounts[${factory}] accounts[${master}] accounts[${locked}] 0 99999999999,${factory},,false\n`;
      text += `setMigrationAgent,create,instance,,${funder},${FINALIZE_CREATE_VALUE},,false\n`;
      text += `setMigrationAgent,finalize,instance,,${funder},,false\n`;
      text += `setMigrationAgent,setMigrationAgent,instance,accounts[${agent}],${master},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'setMigrationMaster') {
    // setMigrationMaster: sender=current master, newMaster != 0.
    // Warmup changes master -> target from new master.
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let factory = helper.random(0, deployAccountCount);
      let master, locked, intermediate, finalMaster;
      do { master = helper.random(0, deployAccountCount); } while(master == factory);
      do { locked = helper.random(0, deployAccountCount); } while(locked == factory || locked == master);
      do { intermediate = helper.random(0, deployAccountCount); } while(intermediate == master);
      do { finalMaster = helper.random(0, deployAccountCount); } while(finalMaster == intermediate);
      let text = `setMigrationMaster,constructor,,accounts[${factory}] accounts[${master}] accounts[${locked}] 0 99999999999,${factory},,false\n`;
      text += `setMigrationMaster,setMigrationMaster,instance,accounts[${intermediate}],${master},,false\n`;
      text += `setMigrationMaster,setMigrationMaster,instance,accounts[${finalMaster}],${intermediate},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

  if(transactionName == 'migrate') {
    // migrate: funding=false, agent != 0, value > 0, balance >= value.
    // Setup: create + finalize + setMigrationAgent
    tracefileCount = transactionCount;
    helper.range(tracefileCount).forEach(testFileIndex => {
      let fileName = `${transactionName}_${testFileIndex}.txt`;
      let factory = helper.random(0, deployAccountCount);
      let master, locked, sender, agent;
      do { master = helper.random(0, deployAccountCount); } while(master == factory);
      do { locked = helper.random(0, deployAccountCount); } while(locked == factory || locked == master);
      do { sender = helper.random(0, deployAccountCount); } while(sender == factory || sender == master || sender == locked);
      do { agent = helper.random(0, deployAccountCount); } while(agent == factory || agent == master || agent == locked || agent == sender);
      let amt1 = helper.random(1, 1001);
      let amt2 = helper.random(1, 1001);
      let text = `migrate,constructor,,accounts[${factory}] accounts[${master}] accounts[${locked}] 0 99999999999,${factory},,false\n`;
      text += `migrate,create,instance,,${sender},${FINALIZE_CREATE_VALUE},,false\n`;
      text += `migrate,finalize,instance,,${sender},,false\n`;
      text += `migrate,setMigrationAgent,instance,accounts[${agent}],${master},,false\n`;
      text += `migrate,migrate,instance,${amt1},${sender},,false\n`;
      text += `migrate,migrate,instance,${amt2},${sender},,true\n`;
      if(!fs.existsSync(path.join(transactionFolderPath, fileName))) {
        fs.writeFileSync(path.join(transactionFolderPath, fileName), text);
      }
    })
  }

})
helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
