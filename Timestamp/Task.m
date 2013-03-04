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

- (void) endTask{
    self.endedAt = [NSDate date];
}

- (NSString *) getHumanizedDescription{
    NSString *strStartedAt = [self.startedAt descriptionWithCalendarFormat:@"%H:%M:%S" timeZone:nil locale:nil];
    
    NSString *strEndedAt = [self.endedAt descriptionWithCalendarFormat:@"%H:%M:%S" timeZone:nil locale:nil];
    
    NSDate *dateOfInterval = [NSDate dateWithTimeIntervalSince1970:[self.endedAt timeIntervalSinceDate:self.startedAt]];
    NSString *strInterval = [dateOfInterval descriptionWithCalendarFormat:@"%H:%M:%S" timeZone:nil locale:nil];
    
    NSString *description = [NSString stringWithFormat:@"Name: %@, Started at: %@, Ended at: %@, Total time: %@", self.name, strStartedAt, strEndedAt, strInterval];
    return description;
}

@end
