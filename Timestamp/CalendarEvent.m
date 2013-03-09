#import "CalendarEvent.h"

@implementation CalendarEvent

EKEventStore *store;
+ (EKEventStore *) getEventStore{
  if (store == nil){
    store = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskEvent];
  }
  return store;
}

// Should remove read-only calendars.
+ (NSArray *) getCalendarNames{
  EKEventStore *store = [self getEventStore];
  
  NSMutableArray *calendarNames = [NSMutableArray array];
  for (EKCalendar *calendar in [store calendarsForEntityType:EKEntityTypeEvent]) {
    NSString *calendarName = calendar.title;
    [calendarNames addObject:calendarName];
  }
  
  return calendarNames;
}

+ (CalendarEvent *) createEventWithTitle:(NSString *)title From:(NSDate *)from InCalendar:(NSString *)calendarName{
  CalendarEvent *event = [[CalendarEvent alloc] init];
  event.title = title;
  event.startedAt = from;
  event.endedAt = from;
  event.calendarName = calendarName;
  [event createOrUpdateEventInCalendar];
  return event;
}

- (void) createOrUpdateEventInCalendar{
  if (self.ekEvent == nil){
    self.ekEvent = [EKEvent eventWithEventStore:[CalendarEvent getEventStore]];
  }
  
  EKCalendar *calendar;
  for (calendar in [store calendarsForEntityType:EKEntityTypeEvent]) {
    if ([calendar.title isEqual:self.calendarName]){
      break;
    }
  }
  
  NSLog(@"Ended At: %@", self.endedAt);
  
  self.ekEvent.startDate = self.startedAt;
  self.ekEvent.endDate = self.endedAt;
  self.ekEvent.title = self.title;
  self.ekEvent.calendar = calendar;
  
  [[CalendarEvent getEventStore] saveEvent:self.ekEvent span:EKSpanThisEvent commit:YES error:nil];
}



@end
