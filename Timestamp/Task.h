@import Foundation;

@class TaskDuration, CalendarEvent;

@interface Task : NSObject

@property (strong, nonatomic) NSDate *startedAt;
@property (strong, nonatomic) NSDate *endedAt;
@property (strong, nonatomic) NSDate *pausedAt;
@property (copy, nonatomic) NSString *name;
@property (readonly, getter = isCancelled) BOOL cancelled;

+ (instancetype)startWithCurrentTimeAndName:(NSString*)name SaveInCalendar:(NSString *)calendarName;
- (instancetype)initWithName:(NSString*)name SaveInCalendar:(NSString *)calendarName;

- (void)finish;
- (void)cancel;
- (void)pause;
- (void)resume;
- (TaskDuration *)duration;
- (BOOL)isFinished;
- (BOOL)isCancelled;

@end




@interface TaskDuration : NSObject

@property (nonatomic) NSInteger hours;
@property (nonatomic) NSInteger minutes;
@property (nonatomic) NSInteger seconds;

+ (instancetype)initWithStartedDate:(NSDate *)startedAt AndEndedDate:(NSDate *)endedAt;

- (id)initWithStartedDate:(NSDate *)startedAt AndEndedDate:(NSDate *)endedAt;
- (NSString *)humanizedPassedTime;

@end