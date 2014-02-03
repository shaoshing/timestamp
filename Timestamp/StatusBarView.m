#import "StatusBarView.h"
#import "StatusBarController.h"
#import "Task.h"

#define StartEngle 270
#define OuterStrokeWidth 2.0
#define StatusIconWidth 28
#define StatusIconHeight 21
#define MenuItemUpdateInterval 10
#define IconUpdateInterval 60
#define IconCenter NSMakePoint(StatusIconWidth/2, (StatusIconHeight+1)/2)

@interface StatusBarView()
  @property (strong, nonatomic) NSTimer *menuItemTimer;
  @property (strong, nonatomic) NSTimer *iconTimer;
  @property (strong, nonatomic) NSImage *icon;
  @property (strong, nonatomic) NSImage *iconActivated;
  @property (strong, nonatomic) NSImage *iconHighlighted;
  @property (strong, nonatomic) NSImage *iconActivatedHighlighted;
  @property (strong, nonatomic) NSStatusItem *statusItem;
  @property (weak, nonatomic) StatusBarController *controller;
@end

@implementation StatusBarView


+ (instancetype) initWithStatusBarController:(StatusBarController *)controller{
  StatusBarView *view = [[StatusBarView alloc] init:controller];
  return view;
}

- (instancetype) init:(StatusBarController *)controller{
  self = [super init];
  if (self){
    self.controller = controller;
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:StatusIconWidth];
    
    [self toggleStatusIcon];
    
    [self.statusItem setHighlightMode:YES];
    [self.statusItem setEnabled:YES];
    [self.statusItem setToolTip:@"Timestamp"];
    [self.statusItem setTarget:self];
    [self.statusItem setTitle:@""];
    [self.statusItem setMenu:self.controller.statusMenu];
  }
  return self;
}

- (void)startTask{
  [self.controller.taskNameMenuItem setHidden:NO];
  [self.controller.taskTimeDescMenuItem setHidden:NO];

  [self toggleStatusIcon];
  [self toggleStartAndStopMenuItems];
  [self updateMenuItemsOfTaskInfo];
  [self updateIcon];

  self.menuItemTimer = [NSTimer scheduledTimerWithTimeInterval:MenuItemUpdateInterval
                                                    target:self
                                                  selector:@selector(updateMenuItemsOfTaskInfo)
                                                  userInfo:nil
                                                   repeats:YES];
  
  self.iconTimer = [NSTimer scheduledTimerWithTimeInterval:IconUpdateInterval
                                                target:self 
                                              selector:@selector(updateIcon)
                                              userInfo:nil repeats:YES];
}

- (void)stopTask{
  [self toggleStatusIcon];
  [self toggleStartAndStopMenuItems];

  [self.menuItemTimer invalidate];
  self.menuItemTimer = nil;
  [self.iconTimer invalidate];
  self.iconTimer = nil;
  [self updateMenuItemsOfTaskInfo];
}

- (void)updateTask{
  if (self.controller.currentTask){
    [self updateMenuItemsOfTaskInfo];
  }
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
  [self.controller.taskNameMenuItem setTitle:[NSString stringWithFormat:strfTaskName,
                                          self.controller.currentTask.name, automationStatus]];

  TaskDuration *duration = [self.controller.currentTask duration];
  [self.controller.taskTimeDescMenuItem setTitle:[duration humanizedPassedTime]];
}




- (void)updateIcon{
  NSLog(@"[StatusBarView] Updated Task Info");

  self.iconActivated = [[NSImage alloc] initWithSize:NSMakeSize(StatusIconWidth, StatusIconHeight)];
  [self.iconActivated setFlipped:YES];

  TaskDuration *duration = [self.controller.currentTask duration];
  CGFloat endAngel = ((int)(360.0*(duration.minutes/60.0)+StartEngle))%360;

  [self.iconActivated lockFocus];
  NSBezierPath* path = [NSBezierPath bezierPath];
  [[self ColorWithR:109 G:123 B:132] setStroke];
  [path setLineWidth:1];
  [path setFlatness:0];
  [path appendBezierPathWithArcWithCenter:IconCenter
                                   radius:7
                               startAngle:StartEngle
                                 endAngle:endAngel];
  [path stroke];
  [path removeAllPoints];

  [[NSColor blackColor] setStroke];
  [path setLineWidth:OuterStrokeWidth];
  [path setFlatness:0];
  [path appendBezierPathWithArcWithCenter:IconCenter
                                   radius:7
                               startAngle:endAngel
                                 endAngle:StartEngle-1];
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
    NSRect textRect = NSMakeRect(center.x-(textWidth/2), center.y-(textHeight/2), textWidth, textHeight);
    [strHour drawInRect:textRect withAttributes:attributes];
  } else{
    [path removeAllPoints];
    [path setLineWidth:0.1];
    [path appendBezierPathWithArcWithCenter:IconCenter
                                     radius:1.5  
                                 startAngle:StartEngle
                                   endAngle:StartEngle-1];
    [path fill];
  }

  [self.iconActivated unlockFocus];
  [self.statusItem setImage:self.iconActivated];


  NSImage *compositeImg = [[NSImage alloc] initWithSize:NSMakeSize(StatusIconWidth, StatusIconHeight)];
  [compositeImg lockFocus];
  [[NSColor whiteColor] setFill];
  NSRectFill(NSMakeRect(0, 0, StatusIconWidth, StatusIconHeight));
  [compositeImg unlockFocus];

  self.iconActivatedHighlighted = [self.iconActivated copy];
  [self.iconActivatedHighlighted lockFocus];
  [compositeImg drawAtPoint:NSMakePoint(0, 0)
                   fromRect:NSMakeRect(0, 0, StatusIconWidth, StatusIconHeight)
                  operation:NSCompositeSourceIn
                   fraction:1.0];
  [self.iconActivatedHighlighted unlockFocus];
  [self.statusItem setAlternateImage:self.iconActivatedHighlighted];
}

- (NSColor *)ColorWithR:(int)red G:(int)gree B:(int)blue{
  return [NSColor colorWithCalibratedRed:red/255.0 green:gree/255.0 blue:blue/255.0 alpha:1.0];
}

- (void)toggleStartAndStopMenuItems{
  [self.controller.stopMenuItem setHidden:![self.controller.stopMenuItem isHidden]];
  [self.controller.startMenuItem setHidden:![self.controller.startMenuItem isHidden]];
  [self.controller.cancelMenuItem setHidden:![self.controller.cancelMenuItem isHidden]];
}

- (void)toggleStatusIcon{
  if (self.icon == nil){
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path setLineWidth:OuterStrokeWidth];
    [path setFlatness:0];

    self.icon = [[NSImage alloc] initWithSize:NSMakeSize(StatusIconWidth, StatusIconHeight)];
    [self.icon setFlipped:YES];
    [self.icon lockFocus];
    [[self ColorWithR:109 G:123 B:132] setStroke];
    [self drawCircleWithPath:path radius:7];
    [path stroke];

    [path removeAllPoints];
    [[self ColorWithR:109 G:123 B:132] setFill];
    [self drawCircleWithPath:path radius:1.5];
    [path fill];
    [path removeAllPoints];
    [self.icon unlockFocus];


    self.iconHighlighted = [[NSImage alloc] initWithSize:NSMakeSize(StatusIconWidth, StatusIconHeight)];
    [self.iconHighlighted setFlipped:YES];
    [self.iconHighlighted lockFocus];
    [[NSColor whiteColor] setStroke];
    [self drawCircleWithPath:path radius:7];
    [path stroke];

    NSShadow * shadow = [[NSShadow alloc] init];
    [shadow setShadowColor:[NSColor whiteColor]];
    [shadow setShadowBlurRadius:5.0];
    [shadow set];
    [path stroke];

    [path removeAllPoints];
    [[NSColor whiteColor] setFill];
    [self drawCircleWithPath:path radius:1.5];
    [path fill];
    [self.iconHighlighted unlockFocus];
  }

  if (self.controller.currentTask == nil ||
      [self.controller.currentTask isFinished] ||
      [self.controller.currentTask isCancelled]){
    [self.statusItem setImage:self.icon];
  }else{
    [self.statusItem setImage:self.iconActivated];
  }

  [self.statusItem setAlternateImage:self.iconHighlighted];
}

- (void)drawCircleWithPath:(NSBezierPath *)path radius:(float)radius{
  [path appendBezierPathWithArcWithCenter:IconCenter
                                   radius:radius
                               startAngle:StartEngle
                                 endAngle:StartEngle-1];
}
@end
