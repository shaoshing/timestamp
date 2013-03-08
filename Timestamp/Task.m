#import "Task.h"

@implementation Task

#pragma mark - Class Methods

+ (Task *) startWithCurrentTimeAndName:(NSString*)name{
    Task *task = [[Task alloc] init];
    task.name = name;
    task.startedAt = [NSDate date];
    return task;
}

#pragma mark - Instance Methods

- (void) finish{
    self.endedAt = [NSDate date];
}

- (Boolean) isFinished{
  return self.endedAt != nil;
}

// todo: duration is returning with 8 hrs ahead of the actual duration.
- (NSDate *) duration{
  NSDate *date = [NSDate date];
  if (self.endedAt != nil){
    date = self.endedAt;
  }
  NSDate *dateOfDuration = [NSDate dateWithTimeIntervalSince1970:[date timeIntervalSinceDate:self.startedAt]];
  return dateOfDuration;
}



@end
