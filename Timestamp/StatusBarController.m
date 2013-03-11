#import "StatusBarController.h"
#import "Task.h"
#import "PreferrencesController.h"
#import "Preferrence.h"

@implementation StatusBarController

#pragma mark - Init

- (void) awakeFromNib{    
  self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  
  NSBundle *bundle = [NSBundle mainBundle];
  self.icon = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"StatusBarIcon" ofType:@"png"]];
  self.iconActivated = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"StatusBarIconActivated" ofType:@"png"]];
  self.iconHighlighted = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"StatusBarIconHighlighted" ofType:@"png"]];
  [self toggleStatusIcon];
  [self.statusItem setAlternateImage:self.iconHighlighted];
    
  [self.statusItem setHighlightMode:YES];
  [self.statusItem setEnabled:YES];
  [self.statusItem setToolTip:@"Timestamp"];
  [self.statusItem setTarget:self];
  [self.statusItem setTitle:@""];
  [self.statusItem setMenu:self.statusMenu];
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

- (void) shouldStartAutomatically:(id)sender{
  if (!self.currentTask){
    self.startedManually = false;
    [self startTask];
  }
}

- (void) shouldStopAutomatically:(id)sender{
  [self stopTaskAndSave:YES];
}




#pragma mark - Private Methods

- (void)updateMenuItemsOfTaskInfo{
  NSLog(@"Updated Task Info");
  if (self.currentTask == nil){
    @throw @"currentTask is nil";
  }
  
  NSString *strfTaskName = @"Working on \"%@\"%@";
  if ([self.currentTask isFinished] || [self.currentTask isCancelled]){
    strfTaskName = @"Previously working on \"%@\"%@";
  }
  NSString *automationStatus = @"";
  if (!self.startedManually){
    automationStatus = @" (WiFi)";
  }
  [self.taskNameMenuItem setTitle:[NSString stringWithFormat:strfTaskName, self.currentTask.name, automationStatus]];
    
  NSString *startedAt = [self.currentTask.startedAt descriptionWithCalendarFormat:@"%H:%M" timeZone:nil locale:nil];
  TaskDuration *duration = [self.currentTask duration];
  NSString *strTimeInfo = [NSString stringWithFormat:@"Started at %@", startedAt];
  if (duration.hours > 0) {
    strTimeInfo = [NSString stringWithFormat:@"%ld hrs and %ld mins passed, since %@", (long)duration.hours, duration.minutes, startedAt];
  }else if (duration.minutes > 0){
    strTimeInfo = [NSString stringWithFormat:@"%ld mins passed, since %@", duration.minutes, startedAt];
  }
  
  [self.taskTimeDescMenuItem setTitle:strTimeInfo];
}

- (void) toggleStartAndStopMenuItems{
  [self.stopMenuItem setHidden:![self.stopMenuItem isHidden]];
  [self.startMenuItem setHidden:![self.startMenuItem isHidden]];
  [self.cancelMenuItem setHidden:![self.cancelMenuItem isHidden]];
}

- (void) toggleStatusIcon{
  if (self.currentTask == nil || [self.currentTask isFinished] || [self.currentTask isCancelled]){
    [self.statusItem setImage:self.icon];
  }else{
    [self.statusItem setImage:self.iconActivated];
  }
}

- (void) startTask{
  if (self.currentTask){
    return;
  }
  
  if (!self.preferrence){
    self.preferrence = self.preferrencesController.preferrence;
  }
  
  self.currentTask = [Task startWithCurrentTimeAndName:self.preferrence.taskName SaveInCalendar:self.preferrence.calendarName];
  
  [self.taskNameMenuItem setHidden:false];
  [self.taskTimeDescMenuItem setHidden:false];
  
  [self toggleStatusIcon];
  [self toggleStartAndStopMenuItems];
  [self updateMenuItemsOfTaskInfo];
  
  self.menuItemTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateMenuItemsOfTaskInfo) userInfo:nil repeats:YES];
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
  
  [self toggleStatusIcon];
  [self toggleStartAndStopMenuItems];
  
  [self.menuItemTimer invalidate];
  self.menuItemTimer = nil;
  [self updateMenuItemsOfTaskInfo];
  
  self.currentTask = nil;
}

@end
