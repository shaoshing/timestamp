#import "StatusBarView.h"
#import "StatusBarController.h"
#import "Task.h"

#define StartEngle 270
#define OuterStrokeWidth 2.0

@implementation StatusBarView


+ (id) initWithStatusBarController:(StatusBarController *)controller{
  StatusBarView *view = [[StatusBarView alloc] init];
  view.controller = controller;
  return view;
}

- (void) initStatusBar{
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
  
  self.menuItemTimer = [NSTimer scheduledTimerWithTimeInterval:MenuItemUpdateInterval target:self selector:@selector(updateMenuItemsOfTaskInfo) userInfo:nil repeats:YES];
  self.iconTimer = [NSTimer scheduledTimerWithTimeInterval:IconUpdateInterval target:self selector:@selector(updateIcon) userInfo:nil repeats:YES];
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




- (void) updateIcon{
  NSLog(@"[StatusBarView] Updated Task Info");
  
  self.iconActivated = [[NSImage alloc] initWithSize:NSMakeSize(StatusIconWidth, StatusIconHeight)];
  [self.iconActivated setFlipped:YES];
  
  NSPoint center = NSMakePoint(11, 11);
  
  TaskDuration *duration = [self.controller.currentTask duration];
  CGFloat endAngel = ((int)(360.0*(duration.minutes/60.0)+StartEngle))%360;
  
  [self.iconActivated lockFocus];
  NSBezierPath* path = [NSBezierPath bezierPath];
  [[self ColorWithR:109 G:123 B:132] setStroke];
  [path setLineWidth:1];
  [path setFlatness:0];
  [path appendBezierPathWithArcWithCenter:center radius:7  startAngle:StartEngle endAngle:endAngel];
  [path stroke];
  [path removeAllPoints];

  [[NSColor blackColor] setStroke];  
  [path setLineWidth:OuterStrokeWidth];
  [path setFlatness:0];
  [path appendBezierPathWithArcWithCenter:center radius:7  startAngle:endAngel endAngle:StartEngle-1];
  [path stroke];
  
  [path removeAllPoints];
  [path setLineWidth:0.1];
  [path appendBezierPathWithArcWithCenter:center radius:1.5  startAngle:StartEngle endAngle:StartEngle-1];
  [path fill];
  [self.iconActivated unlockFocus];
  [self.controller.statusItem setImage:self.iconActivated];
  
  
  
  NSImage *compositeImg = [[NSImage alloc] initWithSize:NSMakeSize(StatusIconWidth, StatusIconHeight)];
  [compositeImg lockFocus];
  [[NSColor whiteColor] setFill];
  NSRectFill(NSMakeRect(0, 0, StatusIconWidth, StatusIconHeight));
  [compositeImg unlockFocus];
  
  self.iconActivatedHighlighted = [self.iconActivated copy];
  [self.iconActivatedHighlighted lockFocus];
  [compositeImg drawAtPoint:NSMakePoint(0, 0) fromRect:NSMakeRect(0, 0, StatusIconWidth, StatusIconHeight) operation:NSCompositeSourceIn fraction:1.0];
  [self.iconActivatedHighlighted unlockFocus];
  [self.controller.statusItem setAlternateImage:self.iconActivatedHighlighted];
}

- (NSColor *) ColorWithR:(int)red G:(int)gree B:(int)blue{
  return [NSColor colorWithCalibratedRed:red/255.0 green:gree/255.0 blue:blue/255.0 alpha:1.0];
}

- (void) toggleStartAndStopMenuItems{
  [self.controller.stopMenuItem setHidden:![self.controller.stopMenuItem isHidden]];
  [self.controller.startMenuItem setHidden:![self.controller.startMenuItem isHidden]];
  [self.controller.cancelMenuItem setHidden:![self.controller.cancelMenuItem isHidden]];
}

- (void) toggleStatusIcon{
  if (self.icon == nil){
    NSPoint center = NSMakePoint(11, 11);
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path setLineWidth:OuterStrokeWidth];
    [path setFlatness:0];
    
    self.icon = [[NSImage alloc] initWithSize:NSMakeSize(StatusIconWidth, StatusIconHeight)];
    [self.icon setFlipped:YES];
    [self.icon lockFocus];
    [[self ColorWithR:109 G:123 B:132] setStroke];
    [path appendBezierPathWithArcWithCenter:center radius:7  startAngle:StartEngle endAngle:StartEngle-1];
    [path stroke];
    [path removeAllPoints];
    [[self ColorWithR:109 G:123 B:132] setFill];
    [path appendBezierPathWithArcWithCenter:center radius:1.5  startAngle:StartEngle endAngle:StartEngle-1];
    [path fill];
    [path removeAllPoints];
    [self.icon unlockFocus];
    
    
    self.iconHighlighted = [[NSImage alloc] initWithSize:NSMakeSize(StatusIconWidth, StatusIconHeight)];
    [self.iconHighlighted setFlipped:YES];
    [self.iconHighlighted lockFocus];
    [[NSColor whiteColor] setStroke];
    [path appendBezierPathWithArcWithCenter:center radius:7  startAngle:StartEngle endAngle:StartEngle-1];
    [path stroke];
    NSShadow * shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor whiteColor]];
    [shadow setShadowBlurRadius:5.0];
    [shadow set];
    [path stroke];
    
    [path removeAllPoints];
    [[NSColor whiteColor] setFill];
    [path appendBezierPathWithArcWithCenter:center radius:1.5  startAngle:StartEngle endAngle:StartEngle-1];
    [path fill];
    [self.iconHighlighted unlockFocus];
  }
  
  if (self.controller.currentTask == nil || [self.controller.currentTask isFinished] || [self.controller.currentTask isCancelled]){
    [self.controller.statusItem setImage:self.icon];
  }else{
    [self.controller.statusItem setImage:self.iconActivated];
  }
  
  [self.controller.statusItem setAlternateImage:self.iconHighlighted];
}
@end
