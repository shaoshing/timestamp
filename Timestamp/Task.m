#import "Task.h"

@implementation Task

+ (Task *) startWithCurrentTimeAndName:(NSString*)name{
    Task *task = [[Task alloc] init];
    task.name = name;
    task.startedAt = [NSDate date];
    return task;
}

- (void) finish{
    self.endedAt = [NSDate date];
}

- (Boolean) isFinished{
  return self.endedAt != nil;
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
  NSDate *duration = [NSDate dateWithTimeIntervalSince1970:[endedAt timeIntervalSinceDate:startedAt]];
  
  NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
  NSDateComponents *dateComponents = [gregorian components:(NSHourCalendarUnit  | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:duration];
  
  // todo: duration is returning with 8 hrs ahead of the actual duration.
  TaskDuration *taskDuration = [[TaskDuration alloc] init];
  taskDuration.hours = [dateComponents hour]+([dateComponents day]+1)*24-8;
  taskDuration.minutes = [dateComponents minute];
  taskDuration.seconds = [dateComponents second];
  
  return taskDuration;
}
@end