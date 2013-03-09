#import "Preferrence.h"
#import "CalendarEvent.h"

// Tutorial:
// http://www.mobiledev.nl/how-to-save-and-load-user-preferences-nsuserdefaults-in-objective-c/

@implementation Preferrence

- (Boolean) load{
  NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
  if (standardUserDefaults == nil) {
    return false;
  }
  
  self.calendarName = [standardUserDefaults stringForKey:@"Calendar Name"];
  self.wifiName = [standardUserDefaults stringForKey:@"WiFi Name"];
  self.taskName = [standardUserDefaults stringForKey:@"Task Name"];
  
  if (!self.calendarName) self.calendarName = [CalendarEvent getCalendarNames][0];
  if (!self.wifiName) self.wifiName = @"";
  if (!self.taskName) self.taskName = @"Cool Stuff";
  
  return true;
}

- (Boolean) save{
  NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults == nil){
    return false;
	}
  
  [standardUserDefaults setObject:self.calendarName forKey:@"Calendar Name"];
  [standardUserDefaults setObject:self.wifiName forKey:@"WiFi Name"];
  [standardUserDefaults setObject:self.taskName forKey:@"Task Name"];
  [standardUserDefaults synchronize];
  return true;
}

@end
