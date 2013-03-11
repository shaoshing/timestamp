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
@property (weak) IBOutlet NSMenuItem *cancelMenuItem;

@property (strong) NSImage *icon;
@property (strong) NSImage *iconActivated;
@property (strong) NSImage *iconHighlighted;
@property (weak) Preferrence *preferrence;

@property (strong) Task *currentTask;
@property (strong) NSTimer *menuItemTimer;
@property Boolean startedManually;

- (IBAction)clickStart:(id)sender;
- (IBAction)clickStop:(id)sender;
- (IBAction)clickCancel:(id)sender;
- (IBAction)clickQuit:(id)sender;
- (IBAction)clickPreferrences:(id)sender;
- (void) pauseTask:(id)sender;
- (void) resumeTask:(id)sender;
- (void) shouldStartAutomatically:(id)sender;
- (void) shouldStopAutomatically:(id)sender;


@end
