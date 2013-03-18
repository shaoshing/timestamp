#import <Cocoa/Cocoa.h>

#define StatusIconWidth 22
#define StatusIconHeight 21
#define MenuItemUpdateInterval 10
#define IconUpdateInterval 60

@class StatusBarController, Task;

@interface StatusBarView : NSObject

@property (weak) StatusBarController *controller;
@property (strong) NSTimer *menuItemTimer;
@property (strong) NSTimer *iconTimer;

@property (strong) NSImage *icon;
@property (strong) NSImage *iconActivated;
@property (strong) NSImage *iconHighlighted;
@property (strong) NSImage *iconActivatedHighlighted;

+ (id) initWithStatusBarController:(StatusBarController *)controller;

- (void) initStatusBar;
- (void) startTask;
- (void) stopTask;


@end
