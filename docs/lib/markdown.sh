#!/bin/bash
echo "=> Generating Singlefile Documentation..."
cat classes/index.flashbotsbundleprovider.md enums/index.flashbotsbundleresolution.md interfaces/index.flashbotsbundlerawtransaction.md interfaces/index.flashbotsbundletransaction.md interfaces/index.flashbotsoptions.md modules/demo.md modules/index.md modules.md > OMNIBUS.md
