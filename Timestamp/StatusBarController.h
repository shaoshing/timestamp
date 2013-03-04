#import <Foundation/Foundation.h>

@class Task;

@interface StatusBarController : NSObject 

@property (weak) IBOutlet NSMenu *statusMenu;
@property (strong) NSStatusItem *statusItem;
@property (strong) Task *currentTask;

- (IBAction)clickStart:(id)sender;
- (IBAction)clickStop:(id)sender;
- (IBAction)clickQuit:(id)sender;

@end
