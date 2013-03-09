#import "AppDelegate.h"
#import "AutomationController.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification{
  
  NSLog(@"hello");
  
  self.automationController = [[AutomationController alloc] init];
  [self.automationController applicationLuanched:self];
}

@end
