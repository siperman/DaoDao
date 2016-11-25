
#import <Foundation/Foundation.h>

extern NSString * const kHadShownTipsKey;
extern NSString * const kSessionCookiesKey;
extern NSString * const kPayAskedNotifyKey;
extern NSString * const kSettingAskedNotifyKey;
extern NSString * const kEverLaunched;
extern NSString * const kReadCertify;
extern NSString * const kAPPLastAlert;
extern NSString * const kAPPLastVersion;
extern NSString * const kAgoLogined;

@interface SYPrefManager : NSObject

+ (void)setBool:(BOOL)yesOrNo forKey:(NSString *)key;

+ (BOOL)boolForKey:(NSString *)key;

+ (void)setObject:(id)obj forKey:(NSString *)key;

+ (id)objectForKey:(NSString *)key;

+ (void)setupCookies;

+ (void)resetCookies;

+ (void)clearCookies;

+ (void)clearData;

+ (NSString *)userPassword;

+ (void)setUserPassword:(NSString *)password;

@end
