#import <Foundation/Foundation.h>

@class TaskDuration, CalendarEvent;

@interface Task : NSObject
{
  @private
  CalendarEvent *_calendarEvent;
  BOOL _cancelled;
}

@property NSDate *startedAt;
@property NSDate *endedAt;
@property NSDate *pausedAt;
@property (copy) NSString *name;

+ (Task *)startWithCurrentTimeAndName:(NSString*)name SaveInCalendar:(NSString *)calendarName;
- (id)initWithName:(NSString*)name SaveInCalendar:(NSString *)calendarName;

- (void)finish;
- (void)cancel;
- (void)pause;
- (void)resume;
- (TaskDuration *)duration;
- (BOOL)isFinished;
- (BOOL)isCancelled;

@end




@interface TaskDuration : NSObject

@property NSInteger hours;
@property NSInteger minutes;
@property NSInteger seconds;

+ (TaskDuration *)initWithStartedDate:(NSDate *)startedAt AndEndedDate:(NSDate *)endedAt;

@end