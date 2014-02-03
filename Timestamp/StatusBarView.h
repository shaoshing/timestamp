@import Cocoa;

@class StatusBarController, Task;

@interface StatusBarView : NSObject

+ (instancetype)initWithStatusBarController:(StatusBarController *)controller;
- (instancetype)init:(StatusBarController *)controller;

- (void)startTask;
- (void)stopTask;
- (void)updateTask;

@end
