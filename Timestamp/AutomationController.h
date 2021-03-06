@import Foundation;

@class WiFi, Preferrence, PreferrencesController, StatusBarController;

@interface AutomationController : NSObject

@property (weak) IBOutlet PreferrencesController *preferrencesController;
@property (weak) IBOutlet StatusBarController *statusBarController;

-(void)wifiChanged:(id)sender NewName:(NSString *)newName;
-(void)wifiPreferrenceChanged:(id)sender;
-(void)systemWillSleep:(id)sender;
-(void)systemDidWake:(id)sender;
-(void)systemWillPowerOff:(id)sender;

@end
