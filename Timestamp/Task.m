#import "Task.h"
#import "CalendarEvent.h"

@interface Task()
  @property (strong, nonatomic) CalendarEvent *calendarEvent;
@end

@implementation Task

+ (instancetype)startWithCurrentTimeAndName:(NSString*)name SaveInCalendar:(NSString *)calendarName{
  Task *task = [[Task alloc] initWithName:name SaveInCalendar:calendarName];
  return task;
}

- (instancetype)initWithName:(NSString*)name SaveInCalendar:(NSString *)calendarName{
  self = [super init];
  
  if (self){
    _name = name;
    _startedAt = [NSDate date];
    
    NSString *calendarEventTitle = [NSString stringWithFormat:@"[Timestamp] Working on \"%@\"", _name];
    self.calendarEvent = [CalendarEvent createEventWithTitle:calendarEventTitle
                                                    From:_startedAt
                                              InCalendar:calendarName];
  }
  
  return self;
}

- (void)finish{
  self.endedAt = [NSDate date];
  if (self.pausedAt){
    self.endedAt = self.pausedAt;
  }
  
  self.calendarEvent.endedAt = self.endedAt;
  self.calendarEvent.title = [NSString stringWithFormat:@"[Timestamp] %@", self.name];
  [self.calendarEvent createOrUpdateEventInCalendar];
  NSLog(@"[Task] Finished at: %@", self.endedAt);
}

- (void)cancel{
  self.endedAt = [NSDate date];
  _cancelled = YES;
  [self.calendarEvent deleteInCalendar];
  NSLog(@"[Task] Canceled at: %@", self.endedAt);
}

- (void)pause{
  self.pausedAt = [NSDate date];
  NSLog(@"[Task] Paused at: %@", self.pausedAt);
}

- (void)resume{
  self.pausedAt = nil;
  NSLog(@"[Task] Resumed");
}

- (BOOL)isFinished{
  return self.endedAt != nil && !self.isCancelled;
}

- (TaskDuration *)duration{
  NSDate *date = [NSDate date];
  if (self.endedAt != nil){
    date = self.endedAt;
  }
  
  return [TaskDuration initWithStartedDate:self.startedAt AndEndedDate:date];
}

@end



@interface TaskDuration()
  @property (strong, nonatomic) NSDate* since;
@end


@implementation TaskDuration
+ (instancetype)initWithStartedDate:(NSDate *)startedAt AndEndedDate:(NSDate *)endedAt{
  return [[TaskDuration alloc] initWithStartedDate:startedAt AndEndedDate:endedAt];
}

- (id)initWithStartedDate:(NSDate *)startedAt AndEndedDate:(NSDate *)endedAt{
  self = [super init];
  if (!self){
    return nil;
  }
  
  NSTimeInterval startedInterval = [startedAt timeIntervalSince1970];
  NSTimeInterval endedInterval = [endedAt timeIntervalSince1970];
  int intervalDifference = endedInterval - startedInterval;

  self.since = startedAt;

  _seconds = intervalDifference%60;
  intervalDifference -= _seconds;

  _minutes = 0;
  if (intervalDifference > 0){
    _minutes = (intervalDifference/60)%60;
    intervalDifference -= _minutes*60;
  }

  _hours = 0;
  if (intervalDifference > 0){
    _hours = (intervalDifference/3600);
  }

  return self;
}

- (NSString *)humanizedPassedTime{
  NSString *startedAt = [self.since descriptionWithCalendarFormat:@"%H:%M" timeZone:nil locale:nil];
  NSString *strTime = [NSString stringWithFormat:@"Just started at %@, Ganbatte!", startedAt];

  if (self.hours > 0) {
    strTime = [NSString stringWithFormat:@"%ld hrs and %ld mins have passed since %@",
                   (long)self.hours, self.minutes, startedAt];

  }else if (self.minutes > 0){
    strTime = [NSString stringWithFormat:@"%ld mins have passed since %@", self.minutes, startedAt];
  }

  if (self.hours == 1){
    strTime = [strTime stringByReplacingOccurrencesOfString:@"hrs" withString:@"hr"];
  }
  if (self.minutes == 1){
    strTime = [strTime stringByReplacingOccurrencesOfString:@"mins" withString:@"min"];
  }
  return strTime;
}
@end