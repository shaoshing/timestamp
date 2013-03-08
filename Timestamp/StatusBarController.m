#import "StatusBarController.h"
#import "Task.h"
#import "PreferrencesController.h"

@implementation StatusBarController

#pragma mark - Init

- (void) awakeFromNib{    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    
  [self.statusItem setHighlightMode:YES];
  [self.statusItem setEnabled:YES];
  [self.statusItem setToolTip:@"Timestamp"];
  [self.statusItem setTarget:self];
  [self.statusItem setTitle:@"Timestamp"];
  [self.statusItem setMenu:self.statusMenu];
}

#pragma mark - Actions
- (IBAction)clickStart:(id)sender {
  self.currentTask = [Task startWithCurrentTimeAndName:@"Some Tasks"];
  
  [self.taskNameMenuItem setHidden:false];
  [self.taskTimeDescMenuItem setHidden:false];
  [self toggleStartAndStopMenuItems];
  [self updateMenuItemsOfTaskInfo];
}

- (IBAction)clickStop:(id)sender {
  [self.currentTask finish];
  [self toggleStartAndStopMenuItems];
  [self updateMenuItemsOfTaskInfo];
}

- (IBAction)clickQuit:(id)sender {
  [NSApp terminate: nil];
}

- (IBAction)clickPreferrences:(id)sender{
  [self.preferrencesController showWindow:self];
}

- (void)updateMenuItemsOfTaskInfo{
  if (self.currentTask == nil){
    return;
  }
  
  NSString *strfTaskName = @"Working on \"%@\":";
  NSString *strfTaskTime = @"%@ (Since %@)";
  if ([self.currentTask isFinished]){
    strfTaskName = @"Previously working on \"%@\":";
  }
  
  [self.taskNameMenuItem setTitle:[NSString stringWithFormat:strfTaskName, self.currentTask.name]];
  NSString *startedAt = [self.currentTask.startedAt descriptionWithCalendarFormat:@"%H:%M" timeZone:nil locale:nil];
  NSString *duration = [[self.currentTask duration] descriptionWithCalendarFormat:@"%H:%M" timeZone:nil locale:nil];
  [self.taskTimeDescMenuItem setTitle:[NSString stringWithFormat:strfTaskTime, duration, startedAt]];

}

- (void) toggleStartAndStopMenuItems{
  [self.stopMenuItem setHidden:![self.stopMenuItem isHidden]];
  [self.startMenuItem setHidden:![self.startMenuItem isHidden]];
}

@end
