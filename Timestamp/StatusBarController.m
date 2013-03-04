#import "StatusBarController.h"
#import "Task.h"

@implementation StatusBarController

#pragma mark - Init

- (void) awakeFromNib{    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setEnabled:YES];
    [self.statusItem setToolTip:@"Timestamp"];
    [self.statusItem setTarget:self];
    [self.statusItem setTitle:@"Timestamp"];
    // statusMenu is automatically loaded from the Nib
    [self.statusItem setMenu:self.statusMenu];
}

#pragma mark - Actions
- (IBAction)clickStart:(id)sender {
    NSLog(@"Click start");
    self.currentTask = [Task startWithCurrentTimeAndName:@"Working"];
}

- (IBAction)clickStop:(id)sender {
    NSLog(@"Click stop");
    [self.currentTask endTask];
    NSLog(@"%@", [self.currentTask getHumanizedDescription]);
}

- (IBAction)clickQuit:(id)sender {
    NSLog(@"Click quit");
    [NSApp terminate: nil];
}
@end
