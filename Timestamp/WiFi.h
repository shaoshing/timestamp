#import <Foundation/Foundation.h>

@class Reachability;

@interface WiFi : NSObject

+ (NSArray *) getNamesOfAvaiableWifi;
+ (NSString *) getNameOfCurrentWifi;
+ (void) monitorWiFiConnectionAndCall:(void(^)(NSString *newWiFiName))callback;


@end
