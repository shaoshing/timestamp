#import "AutomationController.h"
#import "WiFi.h"
#import "Preferrence.h"
#import "PreferrencesController.h"
#import "StatusBarController.h"

@implementation AutomationController

- (void) awakeFromNib{
  self.preferrence = self.preferrencesController.preferrence;
  AutomationController *controller = self;
  [WiFi monitorWiFiConnectionAndCall:^(NSString *newWiFiName){
    [controller wifiChanged:nil NewName:newWiFiName];
  }];
}

-(void) wifiChanged:(id)sender NewName:(NSString *)newName{
  if ([self.preferrence.wifiName length] == 0){
    return;
  }
  
  if ([self.preferrence.wifiName isEqualToString:newName]){
    NSLog(@"should start");
    [self.statusBarController shouldStartAutomatically:self];
  }else{
    NSLog(@"should stop");
    [self.statusBarController shouldStopAutomatically:self];
  }
}

@end
