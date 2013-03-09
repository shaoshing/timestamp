#import <Foundation/Foundation.h>

@class TaskDuration, CalendarEvent;

@interface Task : NSObject

@property (strong) NSDate *startedAt;
@property (strong) NSDate *endedAt;
@property (strong) CalendarEvent *calendarEvent;
@property NSString *name;

+ (Task *) startWithCurrentTimeAndName:(NSString*)name SaveInCalendar:(NSString *)calendarName;

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