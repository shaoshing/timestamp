#import "StatusBarController.h"
#import "Task.h"
#import "PreferrencesController.h"
#import "Preferrence.h"
#import "StatusBarView.h"

@implementation StatusBarController

#pragma mark - Init

- (void) awakeFromNib{    
  self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:StatusIconWidth];
  self.statusBarView = [StatusBarView initWithStatusBarController:self];
  [self.statusBarView initStatusBar];
}

#pragma mark - Actions
- (IBAction)clickStart:(id)sender {
  self.startedManually = true;
  [self startTask];
}

- (IBAction)clickStop:(id)sender {
  [self stopTaskAndSave:YES];
}

- (IBAction)clickCancel:(id)sender {
  [self stopTaskAndSave:NO];
}

- (IBAction)clickQuit:(id)sender {
  [self clickStop:nil];
  [NSApp terminate: nil];
}

- (IBAction)clickPreferrences:(id)sender{
  [self.preferrencesController showWindow:self];
}

- (void) pauseTask:(id)sender{
  if(self.currentTask){
    [self.currentTask pause];
  }
}

- (void) resumeTask:(id)sender{
  if(self.currentTask){
    [self.currentTask resume];
  }
}

- (void) shouldStartAutomatically:(id)sender{
  if (!self.currentTask){
    self.startedManually = false;
    [self startTask];
  }
}

- (void) shouldStopAutomatically:(id)sender{
  [self stopTaskAndSave:YES];
}

- (void) taskNameChanged:(id)sender{
  if (self.currentTask){
    self.currentTask.name = [(PreferrencesController*)sender preferrence].taskName;
    [self.statusBarView updateTask];
  }
}


#pragma mark - Private Methods

- (void) startTask{
  if (self.currentTask){
    return;
  }
  
  if (!self.preferrence){
    self.preferrence = self.preferrencesController.preferrence;
  }
  
  self.currentTask = [Task startWithCurrentTimeAndName:self.preferrence.taskName SaveInCalendar:self.preferrence.calendarName];
  
  [self.statusBarView startTask];
}

- (void) stopTaskAndSave:(Boolean)save{
  if (!self.currentTask){
    return;
  }
  
  if (save){
    [self.currentTask finish];
  }else{
    [self.currentTask cancel];
  }
  
  [self.statusBarView stopTask];
  
  self.currentTask = nil;
}

@end
