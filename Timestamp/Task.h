#import <Foundation/Foundation.h>

@class TaskDuration, CalendarEvent;

@interface Task : NSObject
{
  @private
  CalendarEvent *_calendarEvent;
  Boolean _cancelled;
}

@property NSDate *startedAt;
@property NSDate *endedAt;
@property NSDate *pausedAt;
@property NSString *name;

+ (Task *) startWithCurrentTimeAndName:(NSString*)name SaveInCalendar:(NSString *)calendarName;
- (id) initWithName:(NSString*)name SaveInCalendar:(NSString *)calendarName;

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