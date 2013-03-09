#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface CalendarEvent : NSObject

@property NSString *title;
@property NSDate *from;
@property NSDate *to;
@property EKEvent *ekEvent;

+ (EKEventStore *) getEventStore;
+ (NSArray *) getCalendarNames;
+ (CalendarEvent *) createEventWithTitle:(NSString *)title From:(NSDate *)from;

- (void) createOrUpdateEventInCalendar;

@end
