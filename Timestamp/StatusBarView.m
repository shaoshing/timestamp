#import "StatusBarView.h"
#import "StatusBarController.h"
#import "Task.h"

@implementation StatusBarView


+ (id) initWithStatusBarController:(StatusBarController *)controller{
  StatusBarView *view = [[StatusBarView alloc] init];
  view.controller = controller;
  return view;
}

- (void) initStatusBar{
  NSBundle *bundle = [NSBundle mainBundle];
  self.icon = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"StatusBarIcon" ofType:@"png"]];
  self.iconHighlighted = [[NSImage alloc] initWithContentsOfFile:[bundle pathForResource:@"StatusBarIconHighlighted" ofType:@"png"]];
  [self.controller.statusItem setAlternateImage:self.iconHighlighted];
  
  [self toggleStatusIcon];
  
  [self.controller.statusItem setHighlightMode:YES];
  [self.controller.statusItem setEnabled:YES];
  [self.controller.statusItem setToolTip:@"Timestamp"];
  [self.controller.statusItem setTarget:self];
  [self.controller.statusItem setTitle:@""];
  [self.controller.statusItem setMenu:self.controller.statusMenu];
}

- (void) startTask{
  [self.controller.taskNameMenuItem setHidden:false];
  [self.controller.taskTimeDescMenuItem setHidden:false];
  
  [self toggleStatusIcon];
  [self toggleStartAndStopMenuItems];
  [self updateMenuItemsOfTaskInfo];
  [self updateIcon];
  
  self.menuItemTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateMenuItemsOfTaskInfo) userInfo:nil repeats:YES];
  self.iconTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(updateIcon) userInfo:nil repeats:YES];
}

- (void) stopTask{
  [self toggleStatusIcon];
  [self toggleStartAndStopMenuItems];
  
  [self.menuItemTimer invalidate];
  self.menuItemTimer = nil;
  [self.iconTimer invalidate];
  self.iconTimer = nil;
  [self updateMenuItemsOfTaskInfo];
}

- (void)updateMenuItemsOfTaskInfo{
  NSLog(@"[StatusBarView] Updated Task Info");
  
  if (self.controller.currentTask == nil){
    @throw @"currentTask is nil";
  }
  
  NSString *strfTaskName = @"Working on \"%@\"%@";
  if ([self.controller.currentTask isFinished] || [self.controller.currentTask isCancelled]){
    strfTaskName = @"Previously working on \"%@\"%@";
  }
  NSString *automationStatus = @"";
  if (!self.controller.startedManually){
    automationStatus = @" (WiFi)";
  }
  [self.controller.taskNameMenuItem setTitle:[NSString stringWithFormat:strfTaskName, self.controller.currentTask.name, automationStatus]];
  
  NSString *startedAt = [self.controller.currentTask.startedAt descriptionWithCalendarFormat:@"%H:%M" timeZone:nil locale:nil];
  TaskDuration *duration = [self.controller.currentTask duration];
  NSString *strTimeInfo = [NSString stringWithFormat:@"Just started at %@, Ganbatte!", startedAt];
  if (duration.hours > 0) {
    strTimeInfo = [NSString stringWithFormat:@"%ld hrs and %ld mins passed, since %@", (long)duration.hours, duration.minutes, startedAt];
  }else if (duration.minutes > 0){
    strTimeInfo = [NSString stringWithFormat:@"%ld mins passed, since %@", duration.minutes, startedAt];
  }
  
  if (duration.hours == 1){
    strTimeInfo = [strTimeInfo stringByReplacingOccurrencesOfString:@"hrs" withString:@"hr"];
  }
  if (duration.minutes == 1){
    strTimeInfo = [strTimeInfo stringByReplacingOccurrencesOfString:@"mins" withString:@"min"];
  }
  
  [self.controller.taskTimeDescMenuItem setTitle:strTimeInfo];
}

const int StartEngle = 270;

- (void) updateIcon{
  self.iconActivated = [[NSImage alloc] initWithSize:NSMakeSize(19, 19)];
  [self.iconActivated setFlipped:YES];
  [self.iconActivated lockFocus];
  
  NSBezierPath* thePath = [NSBezierPath bezierPath];
  [[NSColor colorWithCalibratedRed:0.61 green:0.61 blue:0.61 alpha:1] setStroke];
  [thePath setLineWidth:2];
  [thePath setFlatness:0];
  [thePath appendBezierPathWithOvalInRect:NSMakeRect(1,1, 16, 16)];
  [thePath stroke];

  TaskDuration *duration = [self.controller.currentTask duration];
  CGFloat endAngel = ((int)(360.0*(duration.minutes/60.0)+StartEngle))%360;
  NSBezierPath* thePath2 = [NSBezierPath bezierPath];
  [[NSColor blackColor] setStroke];
  [thePath2 setLineWidth:2];
  [thePath2 appendBezierPathWithArcWithCenter:NSMakePoint(9,9) radius:8  startAngle:StartEngle endAngle:endAngel];
  [thePath2 stroke];
  
  
//  [@"1" drawAtPoint:NSMakePoint(0, 0) withAttributes:nil];
  
  [self.iconActivated unlockFocus];

  
  [self.controller.statusItem setImage:self.iconActivated];
  [self.controller.statusItem setAlternateImage:self.iconActivated];
}

- (void) toggleStartAndStopMenuItems{
  [self.controller.stopMenuItem setHidden:![self.controller.stopMenuItem isHidden]];
  [self.controller.startMenuItem setHidden:![self.controller.startMenuItem isHidden]];
  [self.controller.cancelMenuItem setHidden:![self.controller.cancelMenuItem isHidden]];
}

- (void) toggleStatusIcon{
  if (self.controller.currentTask == nil || [self.controller.currentTask isFinished] || [self.controller.currentTask isCancelled]){
    [self.controller.statusItem setImage:self.icon];
  }else{
    [self.controller.statusItem setImage:self.iconActivated];
  }
  [self.controller.statusItem setAlternateImage:self.iconHighlighted];
}
@end
