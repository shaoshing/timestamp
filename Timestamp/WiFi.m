#import "WiFi.h"
#import "CoreWLAN/CoreWLAN.h"

@implementation WiFi


// Detailed example can be found at:
// http://developer.apple.com/library/mac/#samplecode/CoreWLANWirelessManager/Introduction/Intro.html#//apple_ref/doc/uid/DTS40008921-Intro-DontLinkElementID_2
+ (NSArray *) getNamesOfAvaiableWifi{
  // Get the primary network interface (en0, en1, etc.)
  CWInterface *currentInterface = [CWInterface interfaceWithName:nil];
  
  NSArray *networks = [NSMutableArray arrayWithArray:[currentInterface scanForNetworksWithParameters:nil error:nil]];
  
  NSMutableArray *names = [NSMutableArray array];
  for (CWNetwork *network in networks) {
    [names addObject:[network ssid]];
  }

  return names;
}

@end
  