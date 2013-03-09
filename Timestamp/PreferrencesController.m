#import "PreferrencesController.h"
#import "CalendarEvent.h"
#import "WiFi.h"

@implementation PreferrencesController

- (void) awakeFromNib{
  for (NSString *calendarName in [CalendarEvent getCalendarNames]) {
    [self.calendarsPopUp insertItemWithTitle:calendarName atIndex:0];
  }
  
  for (NSString *wifiName in [WiFi getNamesOfAvaiableWifi]) {
    [self.wifisPopUp insertItemWithTitle:wifiName atIndex:0];
  }
}

@end
