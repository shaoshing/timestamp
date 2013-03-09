#import <Foundation/Foundation.h>

@interface Preferrence : NSObject

@property NSString *calendarName;
@property NSString *wifiName;
@property NSString *taskName;

- (Boolean) load;
- (Boolean) save;

@end
