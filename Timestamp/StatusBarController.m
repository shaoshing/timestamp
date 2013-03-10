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
  [self stopTask];
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
  if (!self.startedManually){
    [self stopTask];
  }
}




#pragma mark - Private Methods

- (void)updateMenuItemsOfTaskInfo{
  if (self.currentTask == nil){
    return;
  }
  
  NSString *strfTaskName = @"Working on \"%@\"";
  if ([self.currentTask isFinished]){
    strfTaskName = @"Previously working on \"%@\":";
  }
  [self.taskNameMenuItem setTitle:[NSString stringWithFormat:strfTaskName, self.currentTask.name]];
  
  
  NSString *startedAt = [self.currentTask.startedAt descriptionWithCalendarFormat:@"%H:%M" timeZone:nil locale:nil];
  TaskDuration *duration = [self.currentTask duration];
  NSString *strTimeInfo = [NSString stringWithFormat:@"Just started at %@", startedAt];
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
}

- (void) toggleStatusIcon{
  if (self.currentTask){
    [self.statusItem setImage:self.iconActivated];
  }else{
    [self.statusItem setImage:self.icon];
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

- (void) stopTask{
  if (!self.currentTask){
    return;
  }
  
  [self.currentTask finish];
  self.currentTask = nil;
  
  [self toggleStatusIcon];
  [self toggleStartAndStopMenuItems];
  
  [self.menuItemTimer invalidate];
  self.menuItemTimer = nil;
  [self updateMenuItemsOfTaskInfo];
}

@end
