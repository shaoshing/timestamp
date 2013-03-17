#import "StatusBarView.h"
#import "StatusBarController.h"
#import "Task.h"

#define MenuItemInterval 10
#define IconInterval 60

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
  
  self.menuItemTimer = [NSTimer scheduledTimerWithTimeInterval:MenuItemInterval target:self selector:@selector(updateMenuItemsOfTaskInfo) userInfo:nil repeats:YES];
  self.iconTimer = [NSTimer scheduledTimerWithTimeInterval:IconInterval target:self selector:@selector(updateIcon) userInfo:nil repeats:YES];
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

#define StartEngle 270


- (void) updateIcon{
  self.iconActivated = [[NSImage alloc] initWithSize:NSMakeSize(21, 21)];
  [self.iconActivated setFlipped:YES];
  
  TaskDuration *duration = [self.controller.currentTask duration];
  CGFloat endAngel = ((int)(360.0*(duration.minutes/60.0)+StartEngle))%360;
  
  [self.iconActivated lockFocus];
  
  NSBezierPath* path = [NSBezierPath bezierPath];
  [[self ColorWithR:109 G:123 B:132] setStroke];
  [path setLineWidth:1];
  [path setFlatness:0];
  [path appendBezierPathWithArcWithCenter:NSMakePoint(11,11) radius:7  startAngle:StartEngle endAngle:endAngel];
  [path stroke];
  [path removeAllPoints];

  [[NSColor blackColor] setStroke];  
  [path setLineWidth:1.8];
  [path setFlatness:0];
  [path appendBezierPathWithArcWithCenter:NSMakePoint(11,11) radius:7  startAngle:endAngel endAngle:StartEngle-1];
  [path stroke];
  
  if (duration.hours > 0){
    NSFont* font= [NSFont fontWithName:@"Helvetica" size:10.0];
    NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSCenterTextAlignment];
    
    NSMutableDictionary * attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];
    
    NSString *strHour = [NSString stringWithFormat:@"%d", (int)duration.hours];
    [strHour drawInRect:NSMakeRect(3, 4, 16, 16) withAttributes:attributes];
  } else{
    [path removeAllPoints];
    [path setLineWidth:0.1];
    [path appendBezierPathWithArcWithCenter:NSMakePoint(11,11) radius:1.5  startAngle:StartEngle endAngle:StartEngle-1];
    [path fill];
  }
  
  [self.iconActivated unlockFocus];

  
  [self.controller.statusItem setImage:self.iconActivated];
  [self.controller.statusItem setAlternateImage:self.iconActivated];
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
  if (self.controller.currentTask == nil || [self.controller.currentTask isFinished] || [self.controller.currentTask isCancelled]){
    [self.controller.statusItem setImage:self.icon];
  }else{
    [self.controller.statusItem setImage:self.iconActivated];
  }
  [self.controller.statusItem setAlternateImage:self.iconHighlighted];
}
@end
