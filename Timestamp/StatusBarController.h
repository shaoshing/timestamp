#import <Foundation/Foundation.h>

@class Task, PreferrencesController, Preferrence;

@interface StatusBarController : NSObject

@property (strong) NSStatusItem *statusItem;
@property (weak) IBOutlet NSMenu *statusMenu;
@property (weak) IBOutlet PreferrencesController *preferrencesController;
@property (weak) IBOutlet NSMenuItem *taskNameMenuItem;
@property (weak) IBOutlet NSMenuItem *taskTimeDescMenuItem;
@property (weak) IBOutlet NSMenuItem *startMenuItem;
@property (weak) IBOutlet NSMenuItem *stopMenuItem;

@property (strong) NSImage *icon;
@property (strong) NSImage *iconHighlighted;
@property (weak) Preferrence *preferrence;

@property (strong) Task *currentTask;
@property (strong) NSTimer *menuItemTimer;

- (IBAction)clickStart:(id)sender;
- (IBAction)clickStop:(id)sender;
- (IBAction)clickQuit:(id)sender;
- (IBAction)clickPreferrences:(id)sender;
- (void) shouldStartAutomatically:(id)sender;
- (void) shouldStopAutomatically:(id)sender;

@end
