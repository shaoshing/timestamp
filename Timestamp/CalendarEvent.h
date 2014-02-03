@import Foundation;
@import EventKit;

@interface CalendarEvent : NSObject

@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSDate *startedAt;
@property (strong, nonatomic) NSDate *endedAt;
@property (strong, nonatomic) EKEvent *ekEvent;
@property (copy, nonatomic) NSString *calendarName;

+ (EKEventStore *) getEventStore;
+ (NSArray *) getEditableCalendarNames;
+ (instancetype) createEventWithTitle:(NSString *)title
                                    From:(NSDate *)from
                              InCalendar:(NSString *)calendarName;

- (void)createOrUpdateEventInCalendar;
- (void)deleteInCalendar;

@end
