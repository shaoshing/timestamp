#import "Preferrence.h"
#import "CalendarEvent.h"

#define DataCalendarName @"Calendar Name"
#define DataWiFiName @"WiFi Name"
#define DataPreviousWiFiName @"Previous WiFi Name"
#define DataTaskName @"Task Name"

// Tutorial <How to save and load (user) preferences in Objective c>
// http://goo.gl/5xuwF
//
@implementation Preferrence

- (BOOL)load{
  NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
  if (standardUserDefaults == nil) {
    return NO;
  }
  
  self.calendarName = [standardUserDefaults stringForKey:DataCalendarName];
  self.wifiName = [standardUserDefaults stringForKey:DataWiFiName];
  self.previousWifiName = [standardUserDefaults stringForKey:DataPreviousWiFiName];
  self.taskName = [standardUserDefaults stringForKey:DataTaskName];
  
  if (!self.calendarName) self.calendarName = [CalendarEvent getEditableCalendarNames][0];
  if (!self.wifiName) self.wifiName = @"";
  if (!self.taskName) self.taskName = @"Cool Stuff";
  
  return YES;
}

- (void) setWifiName:(NSString *)name{
  self.previousWifiName = _wifiName;
  _wifiName = name;
}

- (BOOL)save{
  NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults == nil){
    return NO;
	}

  [standardUserDefaults setObject:self.calendarName forKey:DataCalendarName];
  [standardUserDefaults setObject:self.wifiName forKey:DataWiFiName];
  [standardUserDefaults setObject:self.previousWifiName forKey:DataPreviousWiFiName];
  [standardUserDefaults setObject:self.taskName forKey:DataTaskName];
  [standardUserDefaults synchronize];
  return YES;
}

@end
