#import "StatusBarController.h"
#import "Task.h"
#import "PreferrencesController.h"

@implementation StatusBarController

@synthesize statusItem;
@synthesize statusMenu;
@synthesize currentTask;
@synthesize preferrencesController;

#pragma mark - Init

- (void) awakeFromNib{    
    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    [statusItem setHighlightMode:YES];
    [statusItem setEnabled:YES];
    [statusItem setToolTip:@"Timestamp"];
    [statusItem setTarget:self];
    [statusItem setTitle:@"Timestamp"];
    [statusItem setMenu:statusMenu];
}

#pragma mark - Actions
- (IBAction)clickStart:(id)sender {
    currentTask = [Task startWithCurrentTimeAndName:@"Working"];
}

- (IBAction)clickStop:(id)sender {
    [currentTask endTask];
    NSLog(@"%@", [currentTask getHumanizedDescription]);
}

- (IBAction)clickQuit:(id)sender {
    [NSApp terminate: nil];
}

- (IBAction)clickPreferrences:(id)sender{
  [preferrencesController showWindow:self];
}

@end
