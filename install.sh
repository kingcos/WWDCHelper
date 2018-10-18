#!/bin/sh
echo "WWDCHelper will be installed for a litter while, please take a break~\n"
swift package clean
swift test
swift build -c release
cp .build/release/WWDCHelper /usr/local/bin/wwdchelper
cd ..
rm -rf WWDCHelper
echo "\n WWDCHelper has been installed successfully, try `wwdchelper -h`~"