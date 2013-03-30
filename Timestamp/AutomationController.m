#import "AutomationController.h"
#import "WiFi.h"
#import "Preferrence.h"
#import "PreferrencesController.h"
#import "StatusBarController.h"

@implementation AutomationController

- (void)awakeFromNib{
  _preferrence = self.preferrencesController.preferrence;

  NSNotificationCenter *notificationCenter = [[NSWorkspace sharedWorkspace] notificationCenter];

  [notificationCenter addObserver:self
                         selector:@selector(systemDidWake:)
                             name:NSWorkspaceDidWakeNotification
                           object:NULL];

  [notificationCenter addObserver:self
                         selector:@selector(systemWillSleep:)
                             name:NSWorkspaceWillSleepNotification
                           object:NULL];

  [notificationCenter addObserver:self
                         selector:@selector(systemWillPowerOff:)
                             name:NSWorkspaceWillPowerOffNotification
                           object:NULL];

  [self monitorWiFiChanges];
}

-(void)wifiChanged:(id)sender NewName:(NSString *)newName{
  if ([_preferrence.wifiName length] == 0 || _systemInSleep){
    NSLog(@"[Automation] event wifiChanged is ignored%@", _systemInSleep ? @", in Sleep Mode" : @"");
  }else{
    [self determineWhetherToStartWithWiFiName:newName];
  }
  _previousChangedWifiName = [newName copy];
}

-(void)wifiPreferrenceChanged:(id)sender{
  [self determineWhetherToStartWithWiFiName:[WiFi getNameOfCurrentWifi]];
}

-(void)systemWillSleep:(id)sender{
  NSLog(@"[Automation] system will sleep");
  _systemInSleep = YES;
  [self.statusBarController pauseTask:self];
}

-(void)systemDidWake:(id)sender{
  NSLog(@"[Automation] system did awak");
  // Delay the responding to systemDidWake event to wait for WiFi connection
  [NSTimer scheduledTimerWithTimeInterval:5.0
                                   target:self
                                 selector:@selector(respondToSystemDidWakeOnDelay)
                                 userInfo:nil
                                  repeats:NO];
}

-(void)respondToSystemDidWakeOnDelay{
  NSLog(@"[Automation] respond to system did wake event");
  [self determineWhetherToStartWithWiFiName:[WiFi getNameOfCurrentWifi]];
  _systemInSleep = NO;
}

-(void)systemWillPowerOff:(id)sender{
  NSLog(@"[Automation] system will power off");
  [self.statusBarController shouldStopAutomatically:self];
}

#pragma mark - Private Methods

-(void)determineWhetherToStartWithWiFiName:(NSString *)name{
  if (_systemInSleep){
    if ([_preferrence.wifiName isEqualToString:name]){
      NSLog(@"[Automation] should resume");
      [self.statusBarController resumeTask:self];
    }else{
      NSLog(@"[Automation] should stop becuase WiFi changed after wake up.");
      [self.statusBarController shouldStopAutomatically:self];
    }
    return ;
  }

  if ([_preferrence.wifiName isEqualToString:name]){
    if (!self.statusBarController.currentTask){
      NSLog(@"[Automation] should start");
      [self.statusBarController shouldStartAutomatically:self];
      [self sendNotificationWithTitle:@"Start working.."
                                 info:@"Connected to preferred WiFi."];
    }
  }else{
    NSLog(@"Previous WiFi %@", _previousChangedWifiName);
    if ([_previousChangedWifiName isEqualToString:_preferrence.wifiName]
        && self.statusBarController.currentTask){
      NSLog(@"[Automation] should stop");
      [self.statusBarController shouldStopAutomatically:self];
      [self sendNotificationWithTitle:@"Stop working.."
                                 info:@"Disconnected from preferred WiFi."];
    }
  }
}

-(void)monitorWiFiChanges{
  AutomationController *controller = self;
  [WiFi monitorWiFiConnectionAndCall:^(NSString *newWiFiName){
    [controller wifiChanged:nil NewName:newWiFiName];
  }];
}

- (void)sendNotificationWithTitle:(NSString *)title info:(NSString *)info{
  NSUserNotification *notification = [[NSUserNotification alloc] init];
  notification.title = title;
  notification.informativeText = info;

  [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
}

@end
