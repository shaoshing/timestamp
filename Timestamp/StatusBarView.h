#import <Cocoa/Cocoa.h>

#define StatusIconWidth 28
#define StatusIconHeight 21
#define MenuItemUpdateInterval 10
#define IconUpdateInterval 60
#define IconCenter NSMakePoint(StatusIconWidth/2, (StatusIconHeight+1)/2)

@class StatusBarController, Task;

@interface StatusBarView : NSObject
{  
  @private
  NSTimer *_menuItemTimer;
  NSTimer *_iconTimer;
  NSImage *_icon;
  NSImage *_iconActivated;
  NSImage *_iconHighlighted;
  NSImage *_iconActivatedHighlighted;
  NSStatusItem *_statusItem;
  
  __weak StatusBarController *_controller;
}

+ (id)initWithStatusBarController:(StatusBarController *)controller;
- (id)init:(StatusBarController *)controller;

- (void)startTask;
- (void)stopTask;
- (void)updateTask;

@end
