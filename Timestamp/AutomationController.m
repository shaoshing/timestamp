#import "AutomationController.h"
#import "WiFi.h"

@implementation AutomationController

-(void) applicationLuanched:(id)sender{
  [WiFi monitorWiFiConnectionAndCall:^(NSString *newWiFiName){
    NSLog(@"changed to %@", newWiFiName);
  }];
}

@end
