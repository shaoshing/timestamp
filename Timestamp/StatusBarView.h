#import <Cocoa/Cocoa.h>

@class StatusBarController, Task;

@interface StatusBarView : NSObject

@property (weak) StatusBarController *controller;
@property (strong) NSTimer *menuItemTimer;

@property (strong) NSImage *icon;
@property (strong) NSImage *iconActivated;
@property (strong) NSImage *iconHighlighted;

+ (id) initWithStatusBarController:(StatusBarController *)controller;

- (void) initStatusBar;
- (void) startTask;
- (void) stopTask;


@end
