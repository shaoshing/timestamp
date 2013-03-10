#import "Task.h"
#import "CalendarEvent.h"

@implementation Task

+ (Task *) startWithCurrentTimeAndName:(NSString*)name SaveInCalendar:(NSString *)calendarName{
  Task *task = [[Task alloc] init];
  task.name = name;
  task.startedAt = [NSDate date];
  
  NSString *calendarEventTitle = [NSString stringWithFormat:@"[Timestamp] Working on \"%@\"", task.name];
  task.calendarEvent = [CalendarEvent createEventWithTitle:calendarEventTitle From:task.startedAt InCalendar:calendarName];
  return task;
}

- (void) finish{
  self.endedAt = [NSDate date];
  NSLog(@"Finished at: %@", self.endedAt);
  self.calendarEvent.endedAt = self.endedAt;
  self.calendarEvent.title = [NSString stringWithFormat:@"[Timestamp] %@", self.name];
  [self.calendarEvent createOrUpdateEventInCalendar];
}

- (void) cancel{
  self.endedAt = [NSDate date];
  self.cancelled = true;
  NSLog(@"Canceled at: %@", self.endedAt);
  [self.calendarEvent deleteInCalendar];
}

- (Boolean) isFinished{
  return self.endedAt != nil && ![self isCancelled];
}

- (Boolean) isCancelled{
  return self.cancelled;
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