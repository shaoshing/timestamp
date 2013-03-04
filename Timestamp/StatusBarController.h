#import <Foundation/Foundation.h>

@interface StatusBarController : NSObject 

@property (weak) IBOutlet NSMenu *statusMenu;
@property (strong) NSStatusItem *statusItem;

- (IBAction)clickStart:(id)sender;
- (IBAction)clickStop:(id)sender;
- (IBAction)clickQuit:(id)sender;

@end
