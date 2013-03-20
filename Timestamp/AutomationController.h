#import <Foundation/Foundation.h>

@class WiFi, Preferrence, PreferrencesController, StatusBarController;

@interface AutomationController : NSObject
{
  @private
  Boolean _systemInSleep;
  NSString *_previousChangedWifiName;
  __weak Preferrence *_preferrence;
}

@property (weak) IBOutlet PreferrencesController *preferrencesController;
@property (weak) IBOutlet StatusBarController *statusBarController;

-(void) wifiChanged:(id)sender NewName:(NSString *)newName;
-(void) wifiPreferrenceChanged:(id)sender;
-(void) systemWillSleep:(id)sender;
-(void) systemDidWake:(id)sender;
-(void) systemWillPowerOff:(id)sender;

@end
