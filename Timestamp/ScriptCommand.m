#import "ScriptCommand.h"
#import "StatusBarController.h"
#import "Task.h"

@implementation ScriptCommand

-(id)performDefaultImplementation {
  NSString *command = [[self commandDescription] commandName];
  if ([command isEqualToString:@"start task"]){
    [[StatusBarController sharedController] clickStart:self];
  }else if ([command isEqualToString:@"finish task"]){
    [[StatusBarController sharedController] clickStop:self];
  }else if ([command isEqualToString:@"cancel task"]){
    [[StatusBarController sharedController] clickCancel:self];
  }else if ([command isEqualToString:@"describe task"]){
    Task *currentTask = [StatusBarController sharedController].currentTask;
    if (currentTask){
      return [NSString stringWithFormat:@"Working on \"%@\"", currentTask.name];
    }else{
      return @"No task running currently.";
    }
  }

  return nil;
}

@end
