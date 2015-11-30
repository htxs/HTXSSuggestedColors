#鸣谢

本项目是改写了 @jwaitzel 作者的插件 [SuggestedColors](https://github.com/jwaitzel/SuggestedColors)，特此感谢作者 @jwaitzel。

### 项目背景:

项目中使用很多 storyboard 和 xib，会经常在 Interface Builder 中设置颜色值。

一方面，每次都要输入设计同事给出的设计稿标注中的颜色值是件很琐碎和耗时的工作。

另一方面，由于目前项目还没有统一颜色值的使用，导致相同场景下，本应该使用相同颜色值的，但是在 IB 中选择和使用代码未能同步，导致部分场景出现不一致的情况。

为了解决以上 2 个问题，所以参考了 @jwaitzel 作者的插件实现原理，并针对颜色值定义做了相应优化，才促成了本插件的诞生。

### 插件特性:

- Interface Builder 中选择颜色值与代码输入颜色值保持统一。

- 不同项目可以定制一套不同的颜色值。

### 插件缺点

颜色值定义来源于实现文件，所以类名和方法名都需要有一定约束，不能改变。

# HTXSSuggestedColors
---

Xcode Plugin for replacing the system suggested colors.

![Screenshot](https://raw.githubusercontent.com/htxs/HTXSSuggestedColors/master/HTXSSuggestedColors.jpg)

## Use

### 1. Create UIColor category named with UIColor+HTXS.(h/m)

UIColor+HTXS.h
```objective-c
@interface UIColor (HTXS)

@end
```

UIColor+HTXS.m
```objective-c
#import "UIColor+HTXS.h"

@implementation UIColor (HTXS)

@end
```

### 2. Define and implement method to get UIColor instance with `htxs_` prefix

UIColor+HTXS.h
```objective-c
@interface UIColor (HTXS)

/**
 通用输入框光标高亮色: #ff8712
 */
+ (UIColor *)htxs_common_text_tint_color;

/**
 通用文本字体黑色: #333333
 */
+ (UIColor *)htxs_common_dark_text_color;

@end
```

UIColor+HTXS.m
```objective-c
#import "UIColor+HTXS.h"

@implementation UIColor (HTXS)

+ (UIColor *)htxs_common_text_tint_color {
    return UIColorHex(@"#ff8712");
}

+ (UIColor *)htxs_common_dark_text_color {
    return UIColorHex(@"#333333");
}

@end
```

Here `UIColorHex(_hex_)` is macro definition.

UIColor+HTXS.h
```objective-c

#ifndef UIColorHex
#define UIColorHex(_hex_)   [UIColor htxs_colorWithHexString:((_hex_))]
#endif

```

Move to source code to see other helper methods.

### 3. Go to 'Edit' -> 'Reload Colors' to manual reload colors after edit `UIColor+HTXS.m` file. (Normally it can be automatic reload after the file `UIColor+HTXS.m` been edited)

## Important !!!

- Do not change UIColor category file name. `UIColor+HTXS`.(h/m)

- Do not change prefix of method definition. `htxs_`

- Do not change macro definition name. `UIColorHex`

## Installation

Clone and build the plugin yourself, it will be installed to the right location automatically by building it.

In any case, relaunch Xcode to load it.

## License

HTXSSuggestedColors is available under the MIT license. See the LICENSE file for more info.
