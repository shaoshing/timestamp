#import "StatusBarController.h"
#import "Task.h"
#import "PreferrencesController.h"

@implementation StatusBarController

#pragma mark - Init

- (void) awakeFromNib{    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
  
  NSBundle *bundle = [NSBundle mainBundle];
  self.icon = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"StatusBarIcon" ofType:@"png"]];
  self.iconHighlighted = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"StatusBarIconHighlighted" ofType:@"png"]];
  [self.statusItem setImage:self.icon];
  [self.statusItem setAlternateImage:self.iconHighlighted];
    
  [self.statusItem setHighlightMode:YES];
  [self.statusItem setEnabled:YES];
  [self.statusItem setToolTip:@"Timestamp"];
  [self.statusItem setTarget:self];
  [self.statusItem setTitle:@""];
  [self.statusItem setMenu:self.statusMenu];
}

- (void) dealloc{
//  [self.icon release];
//  [self.iconAlter release];
}

#pragma mark - Actions
- (IBAction)clickStart:(id)sender {
  self.currentTask = [Task startWithCurrentTimeAndName:@"Some Tasks"];
  
  [self.taskNameMenuItem setHidden:false];
  [self.taskTimeDescMenuItem setHidden:false];
  
  [self toggleStartAndStopMenuItems];
  [self updateMenuItemsOfTaskInfo];
  
  self.menuItemTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateMenuItemsOfTaskInfo) userInfo:nil repeats:YES];
  
  
}

- (IBAction)clickStop:(id)sender {
  [self.currentTask finish];
  [self toggleStartAndStopMenuItems];
  
  [self.menuItemTimer invalidate];
  self.menuItemTimer = nil;
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
  NSString *strfTaskTime = @"Lasted %d hours and %d minutes, since %@";
  
  if ([self.currentTask isFinished]){
    strfTaskName = @"Previously working on \"%@\":";
  }
  
  [self.taskNameMenuItem setTitle:[NSString stringWithFormat:strfTaskName, self.currentTask.name]];
  NSString *startedAt = [self.currentTask.startedAt descriptionWithCalendarFormat:@"%H:%M" timeZone:nil locale:nil];
  TaskDuration *duration = [self.currentTask duration];
  [self.taskTimeDescMenuItem setTitle:[NSString stringWithFormat:strfTaskTime, duration.hours, duration.minutes, startedAt]];

}

- (void) toggleStartAndStopMenuItems{
  [self.stopMenuItem setHidden:![self.stopMenuItem isHidden]];
  [self.startMenuItem setHidden:![self.startMenuItem isHidden]];
}

@end
