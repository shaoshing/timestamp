#import "StatusBarController.h"
#import "Task.h"
#import "PreferrencesController.h"
#import "Preferrence.h"
#import "StatusBarView.h"

@interface StatusBarController()
  @property (strong, nonatomic) StatusBarView *statusBarView;
@end

@implementation StatusBarController

StatusBarController *shared;

+ (StatusBarController *)sharedController{
  return shared;
}

#pragma mark - Init

- (id)init{
  self = [super init];
  if (self){
    shared = self;
  }
  return self;
}

- (void)awakeFromNib{
  if (!self.currentTask){
    [self statusBarView];
  }
}


#pragma mark - Actions
- (IBAction)clickStart:(id)sender {
  _startedManually = YES;
  [self startTask:nil];
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

- (void)pauseTask:(id)sender{
  if(self.currentTask){
    [self.currentTask pause];
  }
}

- (void)resumeTask:(id)sender{
  if(self.currentTask){
    [self.currentTask resume];
  }
}

- (void)shouldStartAutomatically:(id)sender{
  if (!self.currentTask){
    _startedManually = NO;
    [self startTask:nil];
  }
}

- (void)shouldStopAutomatically:(id)sender{
  [self stopTaskAndSave:YES];
}

- (void)taskNameChanged:(id)sender{
  if (self.currentTask){
    self.currentTask.name = [(PreferrencesController*)sender preferrence].taskName;
    [self.statusBarView updateTask];
  }
}

- (void)startTaskWithName:(NSString *)name{
  _startedManually = YES;
  [self startTask:name];
}


#pragma mark - Private Methods

- (void)startTask:(NSString *)name{
  if (self.currentTask){
    return;
  }
  
  if (!self.preferrence){
    self.preferrence = self.preferrencesController.preferrence;
  }

  if (!name){
    name = self.preferrence.taskName;
  }
  self.currentTask = [Task startWithCurrentTimeAndName:name
                                        SaveInCalendar:self.preferrence.calendarName];
  
  [self.statusBarView startTask];
}

- (void)stopTaskAndSave:(BOOL)saveTask{
  if (!self.currentTask){
    return;
  }
  
  if (saveTask){
    [self.currentTask finish];
  }else{
    [self.currentTask cancel];
  }
  
  [self.statusBarView stopTask];
  
  self.currentTask = nil;
}

- (StatusBarView *)statusBarView{
  if (!_statusBarView){
    _statusBarView = [StatusBarView initWithStatusBarController:self];
  }
  return _statusBarView;
}

@end
