#import "ScriptCommand.h"
#import "StatusBarController.h"
#import "Task.h"

@implementation ScriptCommand

-(id)performDefaultImplementation {
  NSString *command = [[self commandDescription] commandName];
  StatusBarController *statusBarController = [StatusBarController sharedController];
  
  if ([command isEqual:@"start task"]){
    [statusBarController clickStart:self];
    return nil;
  }

  if ([command isEqual:@"finish task"]){
    [statusBarController clickStop:self];
    return nil;
  }

  if ([command isEqual:@"cancel task"]){
    [statusBarController clickCancel:self];
    return nil;
  }

  if ([command isEqual:@"describe task"]){
    Task *currentTask = statusBarController.currentTask;
    if (!currentTask){
      return @"You have no task working on currently.";
    }

    return [NSString stringWithFormat:@"Working on [%@]\n%@",
            currentTask.name,
            [[currentTask duration] humanizedPassedTime]];
  }

  return nil;
}

@end
