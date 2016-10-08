
#import "SYPrefManager.h"
#import <SAMKeychain/SAMKeychain.h>

NSString * const kServiceName = @"DaoDao";

NSString * const kHadShownTipsKey = @"kHadShownTipsKey";
NSString * const kSessionCookiesKey = @"kSessionCookiesKey";
NSString * const kSettingAskedNotifyKey = @"kSettingAskedNotifyKey";
NSString * const kEverLaunched = @"kEverLaunched";
NSString * const kReadCertify = @"kReadCertify";
NSString * const kAPPLastAlert = @"kAPPLastAlert";
NSString * const kAPPLastVersion = @"kAPPLastVersion";
NSString * const kAPPDescKey = @"kAPPDescKey";

@implementation SYPrefManager

+ (void)setBool:(BOOL)yesOrNo forKey:(NSString *)key
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setBool:yesOrNo forKey:key];
    [def synchronize];
}

+ (BOOL)boolForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}

+ (void)setObject:(id)obj forKey:(NSString *)key
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:obj forKey:key];
    [def synchronize];
}

+ (id)objectForKey:(NSString *)key
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (void)setupCookies
{
    NSData *data = [self objectForKey:kSessionCookiesKey];
    if (data) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in cookies) {
            [cookieStorage setCookie:cookie];
        }
    }
}

+ (void)resetCookies
{
    NSData *cookies = [NSKeyedArchiver archivedDataWithRootObject:[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]];
    [self setObject:cookies forKey:kSessionCookiesKey];
}

+ (void)clearCookies
{
    // 记录APP在服务端的行为统计，不清Cookies。
    debugLog(@"Call clear cookies.");
}

+ (void)clearData
{
    [SYPrefManager setObject:nil forKey:kUsernameKey];
    [SYPrefManager setUserPassword:nil];
}

+ (NSString *)userPassword
{
    NSString *username = [self objectForKey:kUsernameKey];
    if (username) {
        NSString *pwd = [SAMKeychain passwordForService:kServiceName account:username];
        if (!pwd) {
            return [SYPrefManager objectForKey:kCodeKey];
        } else {
            return pwd;
        }
    }
    return nil;
}

+ (void)setUserPassword:(NSString *)password
{
    NSString *username = [self objectForKey:kUsernameKey];
    if (username) {
        NSError *error = nil;
        [SAMKeychain setPassword:password forService:kServiceName account:username error:&error];
        
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:kCodeKey];      // Key chain may fail, but its danger
    }
}

@end
