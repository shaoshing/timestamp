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
  [self determineWhetherToStartWithWiFiName:newName];
}

-(void) wifiPreferrenceChanged:(id)sender{
  [self determineWhetherToStartWithWiFiName:[WiFi getNameOfCurrentWifi]];
}


-(void) determineWhetherToStartWithWiFiName:(NSString *)name{
  if ([self.preferrence.wifiName isEqualToString:name]){
    NSLog(@"should start");
    [self.statusBarController shouldStartAutomatically:self];
  }else{
    NSLog(@"should stop");
    [self.statusBarController shouldStopAutomatically:self];
  }
}

@end
