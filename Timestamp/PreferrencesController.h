#import <Cocoa/Cocoa.h>


@class Wifi, Preferrence, AutomationController, StatusBarController;


@interface PreferrencesController : NSWindowController

@property (weak) IBOutlet NSPopUpButton *calendarsPopUp;
@property (weak) IBOutlet NSPopUpButton *wifisPopUp;
@property (weak) IBOutlet NSTextField *taskNameText;
@property (weak) IBOutlet AutomationController *automationController;
@property (weak) IBOutlet StatusBarController *statusBarController;

@property (readonly) Preferrence *preferrence;

- (IBAction)selectCalendar:(id)sender;
- (IBAction)selectWiFi:(id)sender;
- (IBAction)enterTaskName:(id)sender;
- (void)showWindow:(id)sender;

@end
