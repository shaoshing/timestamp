#import <Cocoa/Cocoa.h>

#define StatusIconWidth 28
#define StatusIconHeight 21
#define MenuItemUpdateInterval 10
#define IconUpdateInterval 60
#define IconCenter NSMakePoint(StatusIconWidth/2, (StatusIconHeight+1)/2)

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
- (void) updateTask;


@end
