<p align="center">
<img src="resources/logo.png" alt="WWDCHelper Logo" title="WWDCHelper Logo" width="450">
</p>

<p align="center">
<a href="https://travis-ci.org/kingcos/Learning-WWDC"><img src="https://www.travis-ci.org/kingcos/Learning-WWDC.svg?branch=master"></a>
<a href="https://codecov.io/gh/kingcos/Learning-WWDC"><img src="https://codecov.io/gh/kingcos/Learning-WWDC/branch/master/graph/badge.svg"></a>
<img src="https://img.shields.io/badge/Swift-3.1-orange.svg">
<img src="https://img.shields.io/badge/Platform-macOS-red.svg">
<img src="https://img.shields.io/badge/License-MIT-blue.svg">
</p>

> 受 qiaoxueshi/WWDC_2015_Video_Subtitle，ohoachuck/wwdc-downloader，以及 @onevcat 的视频启发。感谢他们的灵感与努力。👏

[English Version README](README.md)

## 简介

WWDCHelper 是一个 macOS 命令行工具，以便于获取 WWDC 官方的资源。现在，你可以用它直接获取 SD/HD 视频和对应 PDF 文档的链接，也可以直接下载英文或**简体中文**的字幕。

当然，你也可以直接在 [releases](https://github.com/kingcos/WWDCHelper/releases) 页面仅下载 WWDC 2017 的所有字幕。

> **提示**
> 
> 虽然确实写了几年 Swift，但仍有不足，仍有差距。加上对命令行程序的不太了解，可能该项目并非很好，甚至有点怪异。如果您找到了问题、或是建议、又或是 Bug，都欢迎您提出 Issue。我会非常感谢您的帮助。❤️

## 如何使用

### 安装

您的 macOS 需要安装了 [Swift Package Manager](https://swift.org/package-manager/)，或者安装了最新版本的 Xcode 并带有命令行工具。

```sh
> git clone https://github.com/kingcos/WWDCHelper.git
> cd WWDCHelper
> ./install.sh
```

### 运行

```sh
> wwdchelper -h
Usage: WWDCHelper [options]
  -y, --year:
      Setup the year of WWDC. Only support `17` or `2017` now. Default is WWDC 2017.
  -s, --sessions:
      Setup session numbers in WWDC. Default is all.
  -l, --language:
      Setup language of subtitle. Only support `chs` or `eng` now. Default is Simplified Chinese.
  --sd:
      Add sd tag for subtitle filename. Default is for hd.
  -p, --path:
      Setup download path of subtitles. Default is current folder.
  -h, --help:
      Print the help info.
  -v, --version:
      Print the version info.
```

### Demo

- 如果您仅需要 WWDC 2017 中 Session 102 和 202 的信息：

```sh
> wwdchelper -s 102 202
or
> wwdchelper -y 17 -s 102 202
```

### 未实现

> 可能会在未来实现以下特点：

- [x] 一次性下载多个字幕
- [ ] 支持繁体中文字幕
- [ ] 支持中英字幕（同时）
- [ ] 支持早于 WWDC 2017
- [ ] 支持 Linux 🐧

### 参考

- [qiaoxueshi/WWDC_2015_Video_Subtitle](https://github.com/qiaoxueshi/WWDC_2015_Video_Subtitle)
- [ohoachuck/wwdc-downloader](https://github.com/ohoachuck/wwdc-downloader)
- [onevcat](https://github.com/onevcat)
- [onevcat/FengNiao](https://github.com/onevcat/FengNiao)

## WWDC 17 - 笔记

- [102 - Platforms State of the Union](/2017/102)

### 设计

- [819 - Designing for a Global Audience](/2017/819)
- [822 - App Icon Design](/2017/822)
- [823 - Designing Glyphs](/2017/823)

## 许可

MIT