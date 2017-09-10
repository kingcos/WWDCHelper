#!/bin/sh
swift package clean
swift test
swift build -c release
cp .build/release/WWDCHelper /usr/local/bin/wwdchelper
