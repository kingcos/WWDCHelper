# WWDC 2017 - 823 Designing Glyphs

| Date | Notes |
|:-----:|:-----:|
| 2017-07-02 | 首次提交 |

> WWDC 2017 是苹果开发者大会的 2017 版。Session 823 简要介绍了 Glyph（字形，符号等）的设计原则等。

## Glyph & Icon

- Glyph 是单色的，可以用代码（程序化）添加颜色。
- Icon 是彩色的，高渲染的资源文件。

## 高效的 Glyph 设计原则

- 简化的形式（Simplified form）
- 统一的象征（Universal symbology）
  - 在不同的语言环境，生活环境都能清晰无歧义辨识的标志
- 上下文中可读性高（Quickly readable in context）

## Glyph 在系统中的使用场景

- macOS
  - Menu bars
  - Tool bars
  - Touch bar
- iOS
  - Tab bars
  - List views
  - Quick menu (3D Touch)
    - 要比应用内部更大且更重

## Glyph 的设计考量

- 视觉重心（Optical weight）
  - 表面区域较小的 Glyph 可以缩放来达到视觉平衡。
- 线条（Lines）
  - 线宽（Line weight）一致化。
- 位置（Positioning）
  - 以视觉居中为主。

## 制作原则

- 按一个集合来做（Build as a set）
- 上下文中测试（Test in context）
- 在设备中预览（Preview on device)）

## Reference

- [WWDC 17 - 823 Designing Glyphs](https://developer.apple.com/videos/play/wwdc2017/823/)