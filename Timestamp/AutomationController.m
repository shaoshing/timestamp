#import "AutomationController.h"
#import "WiFi.h"
#import "Preferrence.h"
#import "PreferrencesController.h"
#import "StatusBarController.h"

@interface AutomationController()
  @property (getter = isSystemInSleep) BOOL systemInSleep;
  @property (copy, nonatomic) NSString *previousChangedWifiName;
  @property (weak, nonatomic) Preferrence *preferrence;
@end

@implementation AutomationController

- (void)awakeFromNib{
  self.preferrence = self.preferrencesController.preferrence;

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
  if ([self.preferrence.wifiName length] == 0 || self.isSystemInSleep){
    NSLog(@"[Automation] event wifiChanged is ignored%@", self.isSystemInSleep ? @", in Sleep Mode" : @"");
  }else{
    [self determineWhetherToStartWithWiFiName:newName];
  }
  self.previousChangedWifiName = [newName copy];
}

-(void)wifiPreferrenceChanged:(id)sender{
  [self determineWhetherToStartWithWiFiName:[WiFi getNameOfCurrentWifi]];
}

-(void)systemWillSleep:(id)sender{
  NSLog(@"[Automation] system will sleep");
  self.systemInSleep = YES;
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
  self.systemInSleep = NO;
}

-(void)systemWillPowerOff:(id)sender{
  NSLog(@"[Automation] system will power off");
  [self.statusBarController shouldStopAutomatically:self];
}

#pragma mark - Private Methods

-(void)determineWhetherToStartWithWiFiName:(NSString *)name{
  if (self.isSystemInSleep){
    if ([self.preferrence.wifiName isEqualToString:name]){
      NSLog(@"[Automation] should resume");
      [self.statusBarController resumeTask:self];
    }else{
      NSLog(@"[Automation] should stop becuase WiFi changed after wake up.");
      [self.statusBarController shouldStopAutomatically:self];
    }
    return ;
  }

  if ([self.preferrence.wifiName isEqualToString:name]){
    if (!self.statusBarController.currentTask){
      NSLog(@"[Automation] should start");
      [self.statusBarController shouldStartAutomatically:self];
      [self sendNotificationWithTitle:@"Start working.."
                                 info:@"Connected to preferred WiFi."];
    }
  }else{
    NSLog(@"Previous WiFi %@", self.previousChangedWifiName);
    if ([self.previousChangedWifiName isEqualToString:self.preferrence.wifiName]
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
