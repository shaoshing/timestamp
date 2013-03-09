#import <Foundation/Foundation.h>

@class TaskDuration;
@class CalendarEvent;

@interface Task : NSObject

@property (strong) NSDate *startedAt;
@property (strong) NSDate *endedAt;
@property NSString *name;
@property (strong) CalendarEvent *calendarEvent;

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