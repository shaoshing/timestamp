#import <Foundation/Foundation.h>

@class Task;
@class PreferrencesController;

@interface StatusBarController : NSObject 

@property (strong) NSStatusItem *statusItem;
@property (strong) Task *currentTask;

@property (weak) IBOutlet NSMenu *statusMenu;
@property (weak) IBOutlet PreferrencesController *preferrencesController;

- (IBAction)clickStart:(id)sender;
- (IBAction)clickStop:(id)sender;
- (IBAction)clickQuit:(id)sender;
- (IBAction)clickPreferrences:(id)sender;

@end
