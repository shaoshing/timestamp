#import "ScriptCommand.h"
#import "StatusBarController.h"

@implementation ScriptCommand

-(id)performDefaultImplementation {
  NSString *command = [[self commandDescription] commandName];
  if ([command isEqualToString:@"start task"]){
    [[StatusBarController sharedController] clickStart:self];
  }else if ([command isEqualToString:@"finish task"]){
    [[StatusBarController sharedController] clickStop:self];
  }else if ([command isEqualToString:@"cancel task"]){
    [[StatusBarController sharedController] clickCancel:self];
  }

  return nil;
}

@end
