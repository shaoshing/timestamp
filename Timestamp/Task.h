#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (strong) NSDate *startedAt;
@property (strong) NSDate *endedAt;
@property NSString *name;

+ (Task *) startWithCurrentTimeAndName:(NSString*)name;

- (void) finish;
- (NSDate *) duration;
- (Boolean) isFinished;
@end
