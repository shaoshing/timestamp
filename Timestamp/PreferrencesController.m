#import "PreferrencesController.h"
#import "CalendarEvent.h"

@implementation PreferrencesController

- (void) awakeFromNib{
  for (NSString *calendarName in [CalendarEvent getCalendarNames]) {
    [self.calendarsPopUp insertItemWithTitle:calendarName atIndex:0];
  }
}

@end
