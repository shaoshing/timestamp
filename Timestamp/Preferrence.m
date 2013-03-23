#import "Preferrence.h"
#import "CalendarEvent.h"

// Tutorial <How to save and load (user) preferences in Objective c>
// http://goo.gl/5xuwF
//
@implementation Preferrence

- (BOOL)load{
  NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
  if (standardUserDefaults == nil) {
    return NO;
  }
  
  self.calendarName = [standardUserDefaults stringForKey:@"Calendar Name"];
  self.wifiName = [standardUserDefaults stringForKey:@"WiFi Name"];
  self.taskName = [standardUserDefaults stringForKey:@"Task Name"];
  
  if (!self.calendarName) self.calendarName = [CalendarEvent getEditableCalendarNames][0];
  if (!self.wifiName) self.wifiName = @"";
  if (!self.taskName) self.taskName = @"Cool Stuff";
  
  return YES;
}

- (BOOL)save{
  NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
	if (standardUserDefaults == nil){
    return NO;
	}
  
  [standardUserDefaults setObject:self.calendarName forKey:@"Calendar Name"];
  [standardUserDefaults setObject:self.wifiName forKey:@"WiFi Name"];
  [standardUserDefaults setObject:self.taskName forKey:@"Task Name"];
  [standardUserDefaults synchronize];
  return YES;
}

@end
