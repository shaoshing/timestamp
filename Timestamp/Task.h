#import <Foundation/Foundation.h>

@class TaskDuration, CalendarEvent;

@interface Task : NSObject

@property (strong) NSDate *startedAt;
@property (strong) NSDate *endedAt;
@property (strong) NSDate *pausedAt;
@property (strong) CalendarEvent *calendarEvent;
@property NSString *name;
@property Boolean cancelled;

+ (Task *) startWithCurrentTimeAndName:(NSString*)name SaveInCalendar:(NSString *)calendarName;

- (void) finish;
- (void) cancel;
- (void) pause;
- (void) resume;
- (TaskDuration *) duration;
- (Boolean) isFinished;
- (Boolean) isCancelled;

@end




@interface TaskDuration : NSObject

@property NSInteger hours;
@property NSInteger minutes;
@property NSInteger seconds;

+ (TaskDuration *) initWithStartedDate:(NSDate *)startedAt AndEndedDate:(NSDate *)endedAt;

@end