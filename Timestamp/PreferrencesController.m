#import "PreferrencesController.h"
#import "CalendarEvent.h"
#import "WiFi.h"
#import "Preferrence.h"
#import "AutomationController.h"

@implementation PreferrencesController

- (id) init{
  self = [super init];
  if (self){
    self.preferrence = [[Preferrence alloc] init];
    if (![self.preferrence load]) @throw @"Could not load preferrence";
  }

  return self;
}

- (void) awakeFromNib{
  for (NSString *calendarName in [CalendarEvent getEditableCalendarNames]) {
    [self.calendarsPopUp insertItemWithTitle:calendarName atIndex:0];
  }
  
  Boolean isPreferredWiFiAdded = NO;
  for (NSString *wifiName in [WiFi getNamesOfAvaiableWifi]) {
    [self.wifisPopUp insertItemWithTitle:wifiName atIndex:0];
    if ([wifiName isEqualToString:self.preferrence.wifiName]){
      isPreferredWiFiAdded = YES;
    }
  }
  if (!isPreferredWiFiAdded){
    [self.wifisPopUp insertItemWithTitle:self.preferrence.wifiName atIndex:0];
  }

  [self.calendarsPopUp selectItemWithTitle:self.preferrence.calendarName];
  [self.wifisPopUp selectItemWithTitle:self.preferrence.wifiName];
  [self.taskNameText setStringValue:self.preferrence.taskName];
}

- (IBAction)showWindow:(id)sender{
  [super showWindow:sender];
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

- (IBAction)selectCalendar:(id)sender {
  self.preferrence.calendarName = [self.calendarsPopUp.selectedItem title];
  [self.preferrence save];
}

- (IBAction)selectWiFi:(id)sender {
  NSString *newWiFiName = [self.wifisPopUp.selectedItem title];
  
  if ([self.preferrence.wifiName isEqualToString:newWiFiName]){
    return;
  }
  
  self.preferrence.wifiName = newWiFiName;
  [self.preferrence save];
  [self.automationController wifiPreferrenceChanged:self];
}

- (IBAction)enterTaskName:(id)sender {
  self.preferrence.taskName = [self.taskNameText stringValue];
  [self.preferrence save];
}
@end
