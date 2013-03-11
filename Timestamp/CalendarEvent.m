#import "CalendarEvent.h"

@implementation CalendarEvent

EKEventStore *store;
+ (EKEventStore *) getEventStore{
  if (store == nil){
    store = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskEvent];
  }
  return store;
}

+ (NSArray *) getEditableCalendarNames{
  EKEventStore *store = [self getEventStore];
  
  NSMutableArray *calendarNames = [NSMutableArray array];
  for (EKCalendar *calendar in [store calendarsForEntityType:EKEntityTypeEvent]) {
    if (!calendar.allowsContentModifications){
      continue;
    }
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
  EKEvent *ekEvent;
  if (self.ekEvent == nil){
    self.ekEvent = [EKEvent eventWithEventStore:[CalendarEvent getEventStore]];
    ekEvent = self.ekEvent;
  }else{
    ekEvent = [[CalendarEvent getEventStore] eventWithIdentifier:self.ekEvent.eventIdentifier];
  }
  
  EKCalendar *calendar;
  for (calendar in [store calendarsForEntityType:EKEntityTypeEvent]) {
    if ([calendar.title isEqual:self.calendarName]){
      break;
    }
  }
  
  ekEvent.startDate = self.startedAt;
  ekEvent.endDate = self.endedAt;
  ekEvent.title = self.title;
  ekEvent.calendar = calendar;
  
  [[CalendarEvent getEventStore] saveEvent:ekEvent span:EKSpanThisEvent commit:YES error:nil];
}

- (void) deleteInCalendar{
  if (!self.ekEvent){
    return;
  }
  
  [[CalendarEvent getEventStore] removeEvent:self.ekEvent span:EKSpanThisEvent commit:YES error:nil];
}



@end
