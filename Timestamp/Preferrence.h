#import <Foundation/Foundation.h>

@class CalendarEvent;

@interface Preferrence : NSObject

@property NSString *calendarName;
@property NSString *wifiName;
@property NSString *taskName;

- (Boolean) load;
- (Boolean) save;

@end
