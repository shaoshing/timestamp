#import <Foundation/Foundation.h>

@class WiFi, Preferrence, PreferrencesController, StatusBarController;

@interface AutomationController : NSObject

@property (weak) IBOutlet PreferrencesController *preferrencesController;
@property (weak) IBOutlet StatusBarController *statusBarController;

@property Boolean systemInSleep;
@property NSString *previousChangedWifiName;

@property (weak) Preferrence *preferrence;

-(void) wifiChanged:(id)sender NewName:(NSString *)newName;
-(void) wifiPreferrenceChanged:(id)sender;
-(void) systemWillSleep:(id)sender;
-(void) systemDidWake:(id)sender;

@end
