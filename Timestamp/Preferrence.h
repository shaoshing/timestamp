@import Foundation;

@class CalendarEvent;

@interface Preferrence : NSObject

@property (copy, nonatomic) NSString *calendarName;
@property (copy, nonatomic) NSString *wifiName;
@property (copy, nonatomic) NSString *previousWifiName;
@property (copy, nonatomic) NSString *taskName;

- (BOOL)load;
- (BOOL)save;

@end
