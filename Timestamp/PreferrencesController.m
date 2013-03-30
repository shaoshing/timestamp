#import "PreferrencesController.h"
#import "CalendarEvent.h"
#import "WiFi.h"
#import "Preferrence.h"
#import "AutomationController.h"
#import "StatusBarController.h"

@implementation PreferrencesController

- (id)init{
  self = [super init];
  if (self){
    _preferrence = [[Preferrence alloc] init];
    if (![_preferrence load]) @throw @"Could not load preferrence";
  }

  return self;
}

- (void)awakeFromNib{
  assert(self.taskNameText);
  [self.taskNameText setDelegate:self];
}

- (void)showWindow:(id)sender{
  for (NSString *calendarName in [CalendarEvent getEditableCalendarNames]) {
    [self.calendarsPopUp insertItemWithTitle:calendarName atIndex:0];
  }

  NSMutableArray *wifiNames =[[WiFi getNamesOfAvaiableWifi] mutableCopy];
  [wifiNames addObject:self.preferrence.wifiName];
  [wifiNames addObject:self.preferrence.previousWifiName];
  for (NSString *wifiName in wifiNames) {
    if (wifiName){
      [self.wifisPopUp insertItemWithTitle:wifiName atIndex:0];
    }
  }

  [self.calendarsPopUp selectItemWithTitle:self.preferrence.calendarName];
  [self.wifisPopUp selectItemWithTitle:self.preferrence.wifiName];
  [self.taskNameText setStringValue:self.preferrence.taskName];
  
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

- (void)controlTextDidChange:(NSNotification *)aNotification{
  self.preferrence.taskName = [self.taskNameText stringValue];
  [self.preferrence save];
  [self.statusBarController taskNameChanged:self];
}

- (IBAction)importAlfredWorkflow:(id)sender {
  NSBundle *bundle = [NSBundle mainBundle];
  NSString *path = [bundle pathForResource:@"Timestamp" ofType:@"alfredworkflow"];
  [[NSWorkspace sharedWorkspace] openFile:path];
}
@end
