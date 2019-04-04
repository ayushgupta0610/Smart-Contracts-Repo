const path = require('path');
const solc = require('solc');
const fs = require('fs-extra');

const buildPath  = path.resolve(__dirname, 'build');
fs.removeSync(buildPath);

const contract = 'FundConfig.sol';
const fundConfigPath = path.resolve(__dirname, 'contracts', contract);
const source = fs.readFileSync(fundConfigPath, 'utf8');

var input = {
  language: 'Solidity',
  sources: {
      'FundConfig.sol': {
          content: source
      }
  },
  settings: {
      optimizer: {
        // disabled by default
        enabled: true
      },
      outputSelection: {
          '*': {
              '*': [ '*' ]
          }
      }
  }
}

const output = JSON.parse(solc.compile(JSON.stringify(input)));
fs.ensureDirSync(buildPath);

// if(output.errors) {
//   output.errors.forEach(err => {
//       console.log(err.formattedMessage);
//   });
// } else {
  const contracts = output.contracts[contract];
  for (let contractName in contracts) {
      const contract = contracts[contractName];
      fs.writeFileSync(path.resolve(buildPath, `${contractName}.json`), JSON.stringify(contract.abi, null, 2), 'utf8');
  }
// }