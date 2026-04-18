const helper = require('./helper_functions');
const fs = require('fs');
const path = require('path');

const baseURIValue = 1;
const testFolder = path.join(__dirname, '../tracefiles_long/ppg');
const testPath = path.join(testFolder, '/setup.txt');
const setup = fs.readFileSync(testPath, 'utf-8');
let contractName;
let deployAccountCount = 10;
setup.split(/\r?\n/).some(line => {
  const lineArr = line.split(',');
  if (lineArr[0] == 'n') {
    contractName = lineArr[1];
    return true;
  }
  if (lineArr[0] == 'a') {
    deployAccountCount = +lineArr[1];
  }
});

const creatorIndex = 8;
const devIndex = 9;
const price = 30000000000000000;

const transactionFolders = fs.readdirSync(testFolder, { withFileTypes: true })
  .filter(dirent => dirent.isDirectory())
  .map(dirent => dirent.name);
const transactionCounts = transactionFolders.length;

function ensureFile(dir, fileName, text) {
  const file = path.join(dir, fileName);
  if (!fs.existsSync(file)) {
    fs.writeFileSync(file, text);
  }
}

helper.range(transactionCounts).forEach(l => {
  const transactionName = transactionFolders[l];
  const transactionFolderPath = path.join(testFolder, `/${transactionName}`);
  const setupPath = path.join(transactionFolderPath, '/setup.txt');
  let transactionCount = 1;
  if (fs.existsSync(setupPath)) {
    const setupFS = fs.readFileSync(setupPath, 'utf-8');
    setupFS.split(/\r?\n/).forEach(sl => {
      if (sl.startsWith('nt')) {
        transactionCount = +sl.split(',')[1];
      }
    });
  }

  if (transactionName == 'pause') {
    helper.range(transactionCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const text = `pause,constructor,,${baseURIValue} accounts[${creatorIndex}] accounts[${devIndex}],0,,false\npause,pause,instance,false,0,,false\npause,pause,instance,true,0,,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
    });
  }

  if (transactionName == 'setBaseURI') {
    helper.range(transactionCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const b1 = testFileIndex + 10;
      const b2 = testFileIndex + 100;
      const text = `setBaseURI,constructor,,${baseURIValue} accounts[${creatorIndex}] accounts[${devIndex}],0,,false\nsetBaseURI,setBaseURI,instance,${b1},0,,false\nsetBaseURI,setBaseURI,instance,${b2},0,,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
    });
  }

  if (transactionName == 'mint') {
    helper.range(transactionCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const buyerIndex = (testFileIndex % 6) + 1;
      const n1 = (testFileIndex % 4) + 1;
      const n2 = ((testFileIndex + 1) % 4) + 1;
      const v1 = price * n1;
      const v2 = price * n2;
      const text = `mint,constructor,,${baseURIValue} accounts[${creatorIndex}] accounts[${devIndex}],0,,false\nmint,pause,instance,false,0,,false\nmint,mint,instance,accounts[${buyerIndex}] ${n1},${buyerIndex},${v1},false\nmint,mint,instance,accounts[${buyerIndex}] ${n2},${buyerIndex},${v2},true\n`;
      ensureFile(transactionFolderPath, fileName, text);
    });
  }

  if (transactionName == 'withdrawAll') {
    helper.range(transactionCount).forEach(testFileIndex => {
      const fileName = `${transactionName}_${testFileIndex}.txt`;
      const buyerIndex = (testFileIndex % 6) + 1;
      const n1 = (testFileIndex % 3) + 1;
      const n2 = ((testFileIndex + 1) % 3) + 1;
      const v1 = price * n1;
      const v2 = price * n2;
      const text = `withdrawAll,constructor,,${baseURIValue} accounts[${creatorIndex}] accounts[${devIndex}],0,,false\nwithdrawAll,pause,instance,false,0,,false\nwithdrawAll,mint,instance,accounts[${buyerIndex}] ${n1},${buyerIndex},${v1},false\nwithdrawAll,withdrawAll,instance,,0,,false\nwithdrawAll,mint,instance,accounts[${buyerIndex}] ${n2},${buyerIndex},${v2},false\nwithdrawAll,withdrawAll,instance,,0,,true\n`;
      ensureFile(transactionFolderPath, fileName, text);
    });
  }
});

helper.runTests(transactionCounts, transactionFolders, testFolder, contractName, min_version);
