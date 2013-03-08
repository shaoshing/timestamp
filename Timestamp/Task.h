#import <Foundation/Foundation.h>

@class TaskDuration;

@interface Task : NSObject

@property (strong) NSDate *startedAt;
@property (strong) NSDate *endedAt;
@property NSString *name;

+ (Task *) startWithCurrentTimeAndName:(NSString*)name;

- (void) finish;
- (TaskDuration *) duration;
- (Boolean) isFinished;

@end




@interface TaskDuration : NSObject

@property NSInteger hours;
@property NSInteger minutes;
@property NSInteger seconds;

+ (TaskDuration *) initWithStartedDate:(NSDate *)startedAt AndEndedDate:(NSDate *)endedAt;

@end