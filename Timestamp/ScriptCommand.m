#import "ScriptCommand.h"
#import "StatusBarController.h"
#import "Task.h"

@implementation ScriptCommand

-(id)performDefaultImplementation {
  NSString *command = [[self commandDescription] commandName];
  NSDictionary * args = [self evaluatedArguments];
  StatusBarController *statusBarController = [StatusBarController sharedController];

  if ([command isEqual:@"start task"]){
    NSString *taskName = [args valueForKey:@"name"];
    [statusBarController startTaskWithName:taskName];

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
