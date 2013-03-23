#import <Cocoa/Cocoa.h>


@class Wifi, Preferrence, AutomationController, StatusBarController;


@interface PreferrencesController : NSWindowController <NSTextFieldDelegate>

@property (weak) IBOutlet NSPopUpButton *calendarsPopUp;
@property (weak) IBOutlet NSPopUpButton *wifisPopUp;
@property (weak) IBOutlet NSTextField *taskNameText;
@property (weak) IBOutlet AutomationController *automationController;
@property (weak) IBOutlet StatusBarController *statusBarController;

@property (readonly) Preferrence *preferrence;

- (IBAction)selectCalendar:(id)sender;
- (IBAction)selectWiFi:(id)sender;
- (void)showWindow:(id)sender;
// On task name changed
- (void)controlTextDidChange:(NSNotification *)aNotification;
- (IBAction)importAlfredWorkflow:(id)sender;

@end
