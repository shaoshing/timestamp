#import <Cocoa/Cocoa.h>


@class Wifi, Preferrence, AutomationController;


@interface PreferrencesController : NSWindowController

@property (weak) IBOutlet NSPopUpButton *calendarsPopUp;
@property (weak) IBOutlet NSPopUpButton *wifisPopUp;
@property (weak) IBOutlet NSTextField *taskNameText;
@property (weak) IBOutlet AutomationController *automationController;

@property (strong) Preferrence *preferrence;

- (IBAction)selectCalendar:(id)sender;
- (IBAction)selectWiFi:(id)sender;
- (IBAction)enterTaskName:(id)sender;
- (IBAction)showWindow:(id)sender;

@end
