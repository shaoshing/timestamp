#import "AutomationController.h"
#import "WiFi.h"
#import "Preferrence.h"
#import "PreferrencesController.h"
#import "StatusBarController.h"

@implementation AutomationController

- (void) awakeFromNib{
  self.preferrence = self.preferrencesController.preferrence;
  self.previousChangedWifiName = @"";
  AutomationController *controller = self;
  [WiFi monitorWiFiConnectionAndCall:^(NSString *newWiFiName){
    [controller wifiChanged:nil NewName:newWiFiName];
  }];
  
  [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self selector: @selector(systemDidWake:) name: NSWorkspaceDidWakeNotification object: NULL];
  [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self selector: @selector(systemWillSleep:) name: NSWorkspaceWillSleepNotification object: NULL];
  [[[NSWorkspace sharedWorkspace] notificationCenter] addObserver: self selector: @selector(systemWillPowerOff:) name: NSWorkspaceWillPowerOffNotification object: NULL];
}

-(void) wifiChanged:(id)sender NewName:(NSString *)newName{
  if ([self.preferrence.wifiName length] == 0 || self.systemInSleep){
    NSLog(@"[Automation] event wifiChanged is ignored%@", self.systemInSleep ? @", in Sleep Mode" : @"");
    return;
  }
  [self determineWhetherToStartWithWiFiName:newName];
}

-(void) wifiPreferrenceChanged:(id)sender{
  self.previousChangedWifiName = @"";
  [self determineWhetherToStartWithWiFiName:[WiFi getNameOfCurrentWifi]];
}

-(void) systemWillSleep:(id)sender{
  NSLog(@"[Automation] system will sleep");
  self.systemInSleep = YES;
  [self.statusBarController pauseTask:self];
}

-(void) systemDidWake:(id)sender{
  NSLog(@"[Automation] system did awak");
  [self determineWhetherToStartWithWiFiName:[WiFi getNameOfCurrentWifi]];
  self.systemInSleep = NO;
}

-(void) systemWillPowerOff:(id)sender{
  NSLog(@"[Automation] system will power off");
  [self.statusBarController shouldStopAutomatically:self];
}

#pragma mark - Private Methods

-(void) determineWhetherToStartWithWiFiName:(NSString *)name{
  if (self.systemInSleep){
    if ([self.preferrence.wifiName isEqualToString:name]){
      NSLog(@"[Automation] should resume");
      [self.statusBarController resumeTask:self];
    }else{
      NSLog(@"[Automation] should stop becuase WiFi changed after wake up.");
      [self.statusBarController shouldStopAutomatically:self];
    }
  }else if (![self.previousChangedWifiName isEqualToString:name]){
    self.previousChangedWifiName = name;
    if ([self.preferrence.wifiName isEqualToString:name]){
      NSLog(@"[Automation] should start");
      [self.statusBarController shouldStartAutomatically:self];
    }else{
      NSLog(@"[Automation] should stop");
      [self.statusBarController shouldStopAutomatically:self];
    }
  }else{
    NSLog(@"[Automation] ignored. WiFi name is same as previous");
  }
}

@end
