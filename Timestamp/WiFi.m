#import "WiFi.h"
#import "CoreWLAN/CoreWLAN.h"
#import "Reachability.h"

@implementation WiFi


+ (NSString *) getNameOfCurrentWifi{
  CWInterface *wif = [CWInterface interface];
  return wif.ssid;
}


// Detailed example can be found at:
// http://developer.apple.com/library/mac/#samplecode/CoreWLANWirelessManager/Introduction/Intro.html#//apple_ref/doc/uid/DTS40008921-Intro-DontLinkElementID_2

// todo: should return known WiFis
+ (NSArray *) getNamesOfAvaiableWifi{
  // Get the primary network interface (en0, en1, etc.)
  CWInterface *currentInterface = [CWInterface interfaceWithName:nil];
  
  // todo: replace the deprecated method call.
  NSArray *networks = [NSMutableArray arrayWithArray:[currentInterface scanForNetworksWithParameters:nil error:nil]];
  
  NSMutableArray *names = [NSMutableArray array];
  for (CWNetwork *network in networks) {
    [names addObject:[network ssid]];
  }

  return names;
}


// Reachability Doc:
// https://github.com/tonymillion/Reachability
+ (void) monitorWiFiConnectionAndCall:(void(^)(NSString *newWiFiName))callback{
  void (^onConnectionChanged)(Reachability*) = ^(Reachability *reach){
    dispatch_sync(dispatch_get_main_queue(), ^{
      callback([WiFi getNameOfCurrentWifi]);
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
  