#import "CalendarEvent.h"

@implementation CalendarEvent

EKEventStore *store;
+ (EKEventStore *) getEventStore{
  if (store == nil){
    store = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskEvent];
  }
  return store;
}

+ (NSArray *) getCalendarNames{
  EKEventStore *store = [self getEventStore];
  
  NSMutableArray *calendarNames = [NSMutableArray array];
  for (EKCalendar *calendar in [store calendarsForEntityType:EKEntityTypeEvent]) {
    NSString *calendarName = calendar.title;
    [calendarNames addObject:calendarName];
  }
  
  return calendarNames;
}

+ (CalendarEvent *) createEventWithTitle:(NSString *)title From:(NSDate *)from{
  CalendarEvent *event = [[CalendarEvent alloc] init];
  event.title = title;
  event.from = from;
  event.to = from;
  [event createOrUpdateEventInCalendar];
  return event;
}

- (void) createOrUpdateEventInCalendar{
  if (self.ekEvent == nil){
    self.ekEvent = [EKEvent eventWithEventStore:[CalendarEvent getEventStore]];
  }
  
  EKCalendar *calendar;
  for (calendar in [store calendarsForEntityType:EKEntityTypeEvent]) {
    if ([calendar.title isEqual:@"frankyue"]){
      break;
    }
  }
  
  self.ekEvent.startDate = self.from;
  self.ekEvent.endDate = self.to;
  self.ekEvent.title = self.title;
  self.ekEvent.calendar = calendar;
  
  [[CalendarEvent getEventStore] saveEvent:self.ekEvent span:EKSpanThisEvent commit:YES error:nil];
}



@end
