#import <Foundation/Foundation.h>

@class WiFi, Preferrence, PreferrencesController, StatusBarController;

@interface AutomationController : NSObject

@property (weak) IBOutlet PreferrencesController *preferrencesController;
@property (weak) IBOutlet StatusBarController *statusBarController;

@property (weak) Preferrence *preferrence;

-(void) wifiChanged:(id)sender NewName:(NSString *)newName;

@end
