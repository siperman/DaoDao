

#ifndef UtilsMacro_h
#define UtilsMacro_h

#if __LP64__
#define SINT "%ld"
#define UINT "%lu"
#else
#define SINT "%d"
#define UINT "%u"
#endif

#define APPNAME @"道道"
#define _IPHONE80_ 80000

// Block self
#define WeakSelf __weak __typeof(self)weakSelf = self
#define StrongSelf __strong __typeof(weakSelf)strongSelf = weakSelf; \
if (!strongSelf){ \
return; \
}

// Color
#define ColorHex(hex) [UIColor colorFromHexRGB:hex alpha:1]
#define MainColor ColorHex(@"3f2622")
#define SecondColor ColorHex(@"f87127")
#define TitleColor ColorHex(@"ffdb8f")
#define ClickColor ColorHex(@"6b4f4a")
#define CCCColor ColorHex(@"cccccc")
#define TextColor ColorHex(@"9e9e9e")
#define BackgroundColor ColorHex(@"f2f2f2")
#define SepColor ColorHex(@"e9e9e9")
#define BarTintColor ColorHex(@"c2a05f")

// Font
#define TitleTextFont Font(18)
#define BigTextFont Font(17)
#define NormalTextFont Font(15)
#define SmallTextFont Font(12)
#define MiniFont Font(10)

// ShortCut Utils
#define LoadView(nibName) [[[NSBundle mainBundle] loadNibNamed:(nibName) owner:self options:nil] firstObject]
#define Storyboard(storyboardName) [UIStoryboard storyboardWithName:(storyboardName) bundle:[NSBundle mainBundle]]
#define Image(imageName) [UIImage imageNamed:(imageName)]
#define Nib(nibName) [UINib nibWithNibName:(nibName) bundle:nil]
#define Font(fontSize) [UIFont systemFontOfSize:fontSize]
#define BoldFont(fontSize) [UIFont boldSystemFontOfSize:fontSize]
#define Color(r, g, b, a) [UIColor colorWithRed:(r / 255.0) green:(g / 255.0) blue:(b / 255.0) alpha:(a)]
#define RequestUrlFactory(path) [NSString stringWithFormat:@"%@%@", kHostUrl, path]
#define PicUrlFactory(path) [NSString stringWithFormat:@"%@%@", kPicHostUrl, path]
#define TimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000]
#define OnePixelHeight (1 / [UIScreen mainScreen].scale)

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_SIZE [UIScreen mainScreen].bounds.size
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds

#define CORE_DATA_MANAGER [AZCoreDataManager sharedInstance]
#define APP_DELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define POST_NOTIFICATION(name, info) [[NSNotificationCenter defaultCenter] postNotificationName:name object:nil userInfo:info]

#define IS_IPHONE4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IOS8_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue]) >= 8.0)
#define SystemVersion_floatValue    ([[[UIDevice currentDevice] systemVersion] floatValue])

// Load/Save data
#define LOAD_DATA(folderPath, fileName) [NSData dataWithContentsOfFile:[(folderPath) stringByAppendingPathComponent:(fileName)]]
#define SAVE_DATA(data, folderPath, fileName) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ \
[data writeToFile:[(folderPath) stringByAppendingPathComponent:fileName]  atomically:YES]; \
});

// Debug
#ifdef DEBUG
#define debugLog(...) NSLog(__VA_ARGS__)
#define debugMethod() NSLog(@"%s", __func__)
#define debugException(x) debugLog(@"%@", x);debugMethod();
#else
#define debugLog(...)
#define debugMethod()
#define debugException(x)
#endif

#ifdef DEBUG
#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#endif
