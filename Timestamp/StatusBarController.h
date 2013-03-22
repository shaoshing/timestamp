#import <Foundation/Foundation.h>

@class Task, PreferrencesController, Preferrence, StatusBarView;

@interface StatusBarController : NSObject

@property (weak) IBOutlet NSMenu *statusMenu;
@property (weak) IBOutlet PreferrencesController *preferrencesController;
@property (weak) IBOutlet NSMenuItem *taskNameMenuItem;
@property (weak) IBOutlet NSMenuItem *taskTimeDescMenuItem;
@property (weak) IBOutlet NSMenuItem *startMenuItem;
@property (weak) IBOutlet NSMenuItem *stopMenuItem;
@property (weak) IBOutlet NSMenuItem *cancelMenuItem;

@property (weak) Preferrence *preferrence;
@property StatusBarView *statusBarView;
@property Task *currentTask;
@property (readonly) BOOL startedManually;

+ (StatusBarController *) sharedController;

- (IBAction)clickStart:(id)sender;
- (IBAction)clickStop:(id)sender;
- (IBAction)clickCancel:(id)sender;
- (IBAction)clickQuit:(id)sender;
- (IBAction)clickPreferrences:(id)sender;

- (void) pauseTask:(id)sender;
- (void) resumeTask:(id)sender;
- (void) shouldStartAutomatically:(id)sender;
- (void) shouldStopAutomatically:(id)sender;
- (void) taskNameChanged:(id)sender;

@end
