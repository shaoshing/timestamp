#import "AppDelegate.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification{
    [self activateStatusMenu];
}


- (void) activateStatusMenu{
	self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
	[self.statusItem setHighlightMode:YES];
	[self.statusItem setEnabled:YES];
	[self.statusItem setToolTip:@"Timestamp"];
	[self.statusItem setTarget:self];
    [self.statusItem setTitle:@"Timestamp"];
}


@end
