#import <Foundation/Foundation.h>

@class Task;
@class PreferrencesWindowController;

@interface StatusBarController : NSObject 

@property (weak) IBOutlet NSMenu *statusMenu;
@property (strong) NSStatusItem *statusItem;
@property (strong) Task *currentTask;
@property (weak) IBOutlet PreferrencesWindowController *preferrencesWindowController;

- (IBAction)clickStart:(id)sender;
- (IBAction)clickStop:(id)sender;
- (IBAction)clickQuit:(id)sender;

@end
