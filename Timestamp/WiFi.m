#import "WiFi.h"
#import "CoreWLAN/CoreWLAN.h"
#import "Reachability.h"

@implementation WiFi


+ (NSString *)getNameOfCurrentWifi{
  CWInterface *wif = [CWInterface interface];
  return wif.ssid;
}


// Detailed example can be found at:
// http://goo.gl/21w3Y
//
// todo: should return known WiFis
+ (NSArray *)getNamesOfAvaiableWifi{
  // Get the primary network interface (en0, en1, etc.)
  CWInterface *currentInterface = [CWInterface interfaceWithName:nil];
  
  NSSet *networks = [currentInterface scanForNetworksWithName:nil error:nil];
  NSMutableArray *names = [NSMutableArray array];
  for (CWNetwork *network in networks) {
    [names addObject:[network ssid]];
  }

  [names sortUsingSelector:@selector(caseInsensitiveCompare:)];
  return [[names reverseObjectEnumerator] allObjects];;
}


// Reachability Doc:
// https://github.com/tonymillion/Reachability
//
// callback [newWiFiName] will be [nil] if the computer is offline.
+ (void)monitorWiFiConnectionAndCall:(void(^)(NSString *newWiFiName))callback{
  void (^onConnectionChanged)(Reachability*) = ^(Reachability *reach){
    dispatch_sync(dispatch_get_main_queue(), ^{
      NSString *newWiFi = [WiFi getNameOfCurrentWifi];
      NSLog(@"[WiFi] changed to %@", newWiFi);
      callback(newWiFi);
    });
  };
  
  Reachability* reach = [Reachability reachabilityForInternetConnection];
  reach.reachableBlock = onConnectionChanged;
  reach.unreachableBlock = onConnectionChanged;
  [reach startNotifier];
  
  // Invoke the callback manually for the first time, because Reachability won't
  // first the callback if the current internet connection is available.
  callback([WiFi getNameOfCurrentWifi]);
}


@end
  