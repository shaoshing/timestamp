#import "Task.h"
#import "CalendarEvent.h"

@implementation Task

+ (Task *) startWithCurrentTimeAndName:(NSString*)name SaveInCalendar:(NSString *)calendarName{
  Task *task = [[Task alloc] initWithName:name SaveInCalendar:calendarName];
  return task;
}

- (id) initWithName:(NSString*)name SaveInCalendar:(NSString *)calendarName{
  self = [super init];
  
  if (self){
    _name = name;
    _startedAt = [NSDate date];
    
    NSString *calendarEventTitle = [NSString stringWithFormat:@"[Timestamp] Working on \"%@\"", _name];
    _calendarEvent = [CalendarEvent createEventWithTitle:calendarEventTitle
                                                    From:_startedAt
                                              InCalendar:calendarName];
  }
  
  return self;
}

- (void) finish{
  self.endedAt = [NSDate date];
  if (self.pausedAt){
    self.endedAt = self.pausedAt;
  }
  
  _calendarEvent.endedAt = self.endedAt;
  _calendarEvent.title = [NSString stringWithFormat:@"[Timestamp] %@", self.name];
  [_calendarEvent createOrUpdateEventInCalendar];
  NSLog(@"[Task] Finished at: %@", self.endedAt);
}

- (void) cancel{
  self.endedAt = [NSDate date];
  _cancelled = YES;
  [_calendarEvent deleteInCalendar];
  NSLog(@"[Task] Canceled at: %@", self.endedAt);
}

- (void) pause{
  self.pausedAt = [NSDate date];
  NSLog(@"[Task] Paused at: %@", self.pausedAt);
}

- (void) resume{
  self.pausedAt = nil;
  NSLog(@"[Task] Resumed");
}

- (BOOL) isFinished{
  return self.endedAt != nil && ![self isCancelled];
}

- (BOOL) isCancelled{
  return _cancelled;
}

- (TaskDuration *) duration{
  NSDate *date = [NSDate date];
  if (self.endedAt != nil){
    date = self.endedAt;
  }
  
  return [TaskDuration initWithStartedDate:self.startedAt AndEndedDate:date];
}

@end






@implementation TaskDuration
+ (TaskDuration *) initWithStartedDate:(NSDate *)startedAt AndEndedDate:(NSDate *)endedAt{
  NSTimeInterval startedInterval = [startedAt timeIntervalSince1970];
  NSTimeInterval endedInterval = [endedAt timeIntervalSince1970];
  int intervalDifference = endedInterval - startedInterval;
  
  TaskDuration *taskDuration = [[TaskDuration alloc] init];  
  taskDuration.seconds = intervalDifference%60;
  intervalDifference -= taskDuration.seconds;
  
  taskDuration.minutes = 0;
  if (intervalDifference > 0){
    taskDuration.minutes = (intervalDifference/60)%60;
    intervalDifference -= taskDuration.minutes*60;
  }
  
  taskDuration.hours = 0;
  if (intervalDifference > 0){
    taskDuration.hours = (intervalDifference/3600);
  }
  
  return taskDuration;
}
@end