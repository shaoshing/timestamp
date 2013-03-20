#import "StatusBarView.h"
#import "StatusBarController.h"
#import "Task.h"

#define StartEngle 270
#define OuterStrokeWidth 2.0

@implementation StatusBarView


+ (id) initWithStatusBarController:(StatusBarController *)controller{
  StatusBarView *view = [[StatusBarView alloc] init:controller];
  return view;
}

- (id) init:(StatusBarController *)controller{
  self = [super init];
  if (self){
    _controller = controller;
    _statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:StatusIconWidth];
    
    [self toggleStatusIcon];
    
    [_statusItem setHighlightMode:YES];
    [_statusItem setEnabled:YES];
    [_statusItem setToolTip:@"Timestamp"];
    [_statusItem setTarget:self];
    [_statusItem setTitle:@""];
    [_statusItem setMenu:_controller.statusMenu];
  }
  return self;
}

- (void) startTask{
  [_controller.taskNameMenuItem setHidden:false];
  [_controller.taskTimeDescMenuItem setHidden:false];

  [self toggleStatusIcon];
  [self toggleStartAndStopMenuItems];
  [self updateMenuItemsOfTaskInfo];
  [self updateIcon];

  _menuItemTimer = [NSTimer scheduledTimerWithTimeInterval:MenuItemUpdateInterval target:self selector:@selector(updateMenuItemsOfTaskInfo) userInfo:nil repeats:YES];
  _iconTimer = [NSTimer scheduledTimerWithTimeInterval:IconUpdateInterval target:self selector:@selector(updateIcon) userInfo:nil repeats:YES];
}

- (void) stopTask{
  [self toggleStatusIcon];
  [self toggleStartAndStopMenuItems];

  [_menuItemTimer invalidate];
  _menuItemTimer = nil;
  [_iconTimer invalidate];
  _iconTimer = nil;
  [self updateMenuItemsOfTaskInfo];
}

- (void) updateTask{
  if (_controller.currentTask){
    [self updateMenuItemsOfTaskInfo];
  }
}

- (void)updateMenuItemsOfTaskInfo{
  NSLog(@"[StatusBarView] Updated Task Info");

  if (_controller.currentTask == nil){
    @throw @"currentTask is nil";
  }

  NSString *strfTaskName = @"Working on \"%@\"%@";
  if ([_controller.currentTask isFinished] || [_controller.currentTask isCancelled]){
    strfTaskName = @"Previously working on \"%@\"%@";
  }
  NSString *automationStatus = @"";
  if (!_controller.startedManually){
    automationStatus = @" (WiFi)";
  }
  [_controller.taskNameMenuItem setTitle:[NSString stringWithFormat:strfTaskName, _controller.currentTask.name, automationStatus]];

  NSString *startedAt = [_controller.currentTask.startedAt descriptionWithCalendarFormat:@"%H:%M" timeZone:nil locale:nil];
  TaskDuration *duration = [_controller.currentTask duration];
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

  [_controller.taskTimeDescMenuItem setTitle:strTimeInfo];
}




- (void) updateIcon{
  NSLog(@"[StatusBarView] Updated Task Info");

  _iconActivated = [[NSImage alloc] initWithSize:NSMakeSize(StatusIconWidth, StatusIconHeight)];
  [_iconActivated setFlipped:YES];

  TaskDuration *duration = [_controller.currentTask duration];
  CGFloat endAngel = ((int)(360.0*(duration.minutes/60.0)+StartEngle))%360;

  [_iconActivated lockFocus];
  NSBezierPath* path = [NSBezierPath bezierPath];
  [[self ColorWithR:109 G:123 B:132] setStroke];
  [path setLineWidth:1];
  [path setFlatness:0];
  [path appendBezierPathWithArcWithCenter:IconCenter radius:7  startAngle:StartEngle endAngle:endAngel];
  [path stroke];
  [path removeAllPoints];

  [[NSColor blackColor] setStroke];
  [path setLineWidth:OuterStrokeWidth];
  [path setFlatness:0];
  [path appendBezierPathWithArcWithCenter:IconCenter radius:7  startAngle:endAngel endAngle:StartEngle-1];
  [path stroke];



  if (duration.hours > 0){
    int textHeight = 14;
    int textWidth = 16;
    NSPoint center = IconCenter;
    
    NSFont* font= [NSFont fontWithName:@"Helvetica" size:11.0];
    NSMutableParagraphStyle * paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setAlignment:NSCenterTextAlignment];

    NSMutableDictionary * attributes = [[NSMutableDictionary alloc] init];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:paragraphStyle forKey:NSParagraphStyleAttributeName];

    NSString *strHour = [NSString stringWithFormat:@"%d", (int)duration.hours];
    [strHour drawInRect:NSMakeRect(center.x-(textWidth/2), center.y-(textHeight/2), textWidth, textHeight) withAttributes:attributes];
  } else{
    [path removeAllPoints];
    [path setLineWidth:0.1];
    [path appendBezierPathWithArcWithCenter:IconCenter radius:1.5  startAngle:StartEngle endAngle:StartEngle-1];
    [path fill];
  }

  [_iconActivated unlockFocus];
  [_statusItem setImage:_iconActivated];


  NSImage *compositeImg = [[NSImage alloc] initWithSize:NSMakeSize(StatusIconWidth, StatusIconHeight)];
  [compositeImg lockFocus];
  [[NSColor whiteColor] setFill];
  NSRectFill(NSMakeRect(0, 0, StatusIconWidth, StatusIconHeight));
  [compositeImg unlockFocus];

  _iconActivatedHighlighted = [_iconActivated copy];
  [_iconActivatedHighlighted lockFocus];
  [compositeImg drawAtPoint:NSMakePoint(0, 0) fromRect:NSMakeRect(0, 0, StatusIconWidth, StatusIconHeight) operation:NSCompositeSourceIn fraction:1.0];
  [_iconActivatedHighlighted unlockFocus];
  [_statusItem setAlternateImage:_iconActivatedHighlighted];
}

- (NSColor *) ColorWithR:(int)red G:(int)gree B:(int)blue{
  return [NSColor colorWithCalibratedRed:red/255.0 green:gree/255.0 blue:blue/255.0 alpha:1.0];
}

- (void) toggleStartAndStopMenuItems{
  [_controller.stopMenuItem setHidden:![_controller.stopMenuItem isHidden]];
  [_controller.startMenuItem setHidden:![_controller.startMenuItem isHidden]];
  [_controller.cancelMenuItem setHidden:![_controller.cancelMenuItem isHidden]];
}

- (void) toggleStatusIcon{
  if (_icon == nil){
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path setLineWidth:OuterStrokeWidth];
    [path setFlatness:0];

    _icon = [[NSImage alloc] initWithSize:NSMakeSize(StatusIconWidth, StatusIconHeight)];
    [_icon setFlipped:YES];
    [_icon lockFocus];
    [[self ColorWithR:109 G:123 B:132] setStroke];
    [path appendBezierPathWithArcWithCenter:IconCenter radius:7  startAngle:StartEngle endAngle:StartEngle-1];
    [path stroke];
    [path removeAllPoints];
    [[self ColorWithR:109 G:123 B:132] setFill];
    [path appendBezierPathWithArcWithCenter:IconCenter radius:1.5  startAngle:StartEngle endAngle:StartEngle-1];
    [path fill];
    [path removeAllPoints];
    [_icon unlockFocus];


    _iconHighlighted = [[NSImage alloc] initWithSize:NSMakeSize(StatusIconWidth, StatusIconHeight)];
    [_iconHighlighted setFlipped:YES];
    [_iconHighlighted lockFocus];
    [[NSColor whiteColor] setStroke];
    [path appendBezierPathWithArcWithCenter:IconCenter radius:7  startAngle:StartEngle endAngle:StartEngle-1];
    [path stroke];
    NSShadow * shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor whiteColor]];
    [shadow setShadowBlurRadius:5.0];
    [shadow set];
    [path stroke];

    [path removeAllPoints];
    [[NSColor whiteColor] setFill];
    [path appendBezierPathWithArcWithCenter:IconCenter radius:1.5  startAngle:StartEngle endAngle:StartEngle-1];
    [path fill];
    [_iconHighlighted unlockFocus];
  }

  if (_controller.currentTask == nil || [_controller.currentTask isFinished] || [_controller.currentTask isCancelled]){
    [_statusItem setImage:_icon];
  }else{
    [_statusItem setImage:_iconActivated];
  }

  [_statusItem setAlternateImage:_iconHighlighted];
}
@end
