<p align="center">
<img src="resources/logo.png" alt="WWDCHelper Logo" title="WWDCHelper Logo" width="450">
</p>

<p align="center">
<a href="https://travis-ci.org/kingcos/WWDCHelper"><img src="https://www.travis-ci.org/kingcos/WWDCHelper.svg?branch=master"></a>
<a href="https://codecov.io/gh/kingcos/WWDCHelper"><img src="https://codecov.io/gh/kingcos/WWDCHelper/branch/master/graph/badge.svg"></a>
<img src="https://img.shields.io/badge/Swift-4.2-orange.svg">
<img src="https://img.shields.io/badge/Platform-macOS-red.svg">
<img src="https://img.shields.io/badge/License-MIT-blue.svg">
</p>

# WWDCHelper

English | [中文](README_CN.md)

> Inspired by qiaoxueshi/WWDC_2015_Video_Subtitle, ohoachuck/wwdc-downloader, and @onevcat's videos. Thanks for their inspiration and efforts. 👏

## Info

WWDCHelper is a command line tool on macOS for you to get WWDC info easily. Now you can get download links of SD/HD video & PDF, and download subtitles in English, Janpanese (only WWDC 2018), and even Simplified Chinese directly by it.

You can also download subtitles at the [releases](https://github.com/kingcos/WWDCHelper/releases) page.

> **Notice:**
> 
> Although I have written in Swift for years, I still have a lot to learn about Swift. And to be honest, CLI (Command Line Interface) is not familiar for me. So this program is not perfect, even a little wired. So you can issue me if you have any questions, advices or find some bugs . I will be very appreciated for your help. ❤️

## How

### Install

You should have [Swift Package Manager](https://swift.org/package-manager/) installed or latest Xcode installed with command line tools in your macOS.

```sh
> git clone https://github.com/kingcos/WWDCHelper.git
> cd WWDCHelper
> ./install.sh
```

### Run

![WWDCHelper -h](WWDCHelper-h.png)

### Demo

- *Update*: If you want to get all sessions info of WWDC 2018 (Including videos' download links):

```sh
> wwdchelper -y 2018
```

- *Update*: - If you want to download subtitles in English of WWDC 2018:

```sh
# HD Videos：
> wwdchelper -y 2018 -l eng
or
# SD Videos：
> wwdchelper -y 2018 --sd -l eng
```

- If you just want to get Session 102 & 202 info of WWDC 2018:

```sh
> wwdchelper -s 102 202
or
> wwdchelper -y 2018 -s 102 202
or
> wwdchelper --year 2018 --sesions 102 202
```

- If you want to download subtitles in English of Session 102 & 202 for SD videos:

```sh
> wwdchelper -s 102 202 -l eng --sd
or
> wwdchelper --year 2018 --sessions 102 202 --language eng --sd
```

- If you want to download **all** subtitles in English for HD videos, and specify the path (**NOT recommend**):

```sh
> wwdchelper -l eng -p /Users/kingcos/Downloads/hd/eng/
```

### NOT Implemented

> Maybe implement these features in the future.

- [x] Download multiple subtitles at once
- [x] Support subtitles in all languages that provided
- [x] Support ALL WWDC (2012 ~ 2018)
- [x] Swift 4.1
- [x] Swift 4.2
- [ ] Support for Linux 🐧

### Reference

- [qiaoxueshi/WWDC_2015_Video_Subtitle](https://github.com/qiaoxueshi/WWDC_2015_Video_Subtitle)
- [ohoachuck/wwdc-downloader](https://github.com/ohoachuck/wwdc-downloader)
- [onevcat](https://github.com/onevcat)
- [onevcat/FengNiao](https://github.com/onevcat/FengNiao)

## LICENSE

- MIT
