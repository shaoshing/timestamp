#import <Foundation/Foundation.h>

@class CalendarEvent;

@interface Preferrence : NSObject

@property (copy) NSString *calendarName;
@property (copy) NSString *wifiName;
@property (copy) NSString *taskName;

- (BOOL)load;
- (BOOL)save;

@end
