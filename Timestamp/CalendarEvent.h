#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface CalendarEvent : NSObject

@property NSString *title;
@property NSDate *startedAt;
@property NSDate *endedAt;
@property EKEvent *ekEvent;
@property NSString *calendarName;

+ (EKEventStore *) getEventStore;
+ (NSArray *) getEditableCalendarNames;
+ (CalendarEvent *) createEventWithTitle:(NSString *)title
                                    From:(NSDate *)from
                              InCalendar:(NSString *)calendarName;

- (void) createOrUpdateEventInCalendar;
- (void) deleteInCalendar;

@end
