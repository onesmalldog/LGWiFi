//
//  ViewController.m
//  text_Wifi
//
//  Created by 东途 on 2016/10/21.
//  Copyright © 2016年 displayten. All rights reserved.
//

#import "ViewController.h"
#import "LGWifi.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 监听wifi状态
    // CWWiFiClient   - (BOOL)startMonitoringEventWithType
    
    // keychain
    // CoreWLANUtil.h
    
    
    BOOL result = false;
    
    result = [self way3];
    
    if (result) {
        NSLog(@"success");
    }
    else NSLog(@"failure");
}

- (BOOL)way1 {
    
    NSSet *networks = [LGWiFi findNetworks];
    for (CWNetwork *network in networks) {
        if ([network.ssid isEqualToString:@"WiFi Name"]) {
            NSLog(@"connecting...");
            return [network connectToThisNetworkWithPassword:@"WiFi Password"];
        }
    }
    return NO;
}
- (BOOL)way2 {
    NSSet *networks2 = [LGWiFi findNetworks];
    for (CWNetwork *network in networks2) {
        if ([network.ssid isEqualToString:@"WiFi Name"]) {
            NSLog(@"connecting...");
            return [LGWiFi connectWifiWithNetwork:network password:@"WiFi Password"];
        }
    }

    return NO;
}
- (BOOL)way3 {
    NSSet *ssids = [LGWiFi findNetworksToSSID];
    for (NSString *ssid in ssids) {
        if ([ssid isEqualToString:@"WiFi Name"]) {
            NSLog(@"connecting...");
            return [LGWiFi connectWifiFromName:ssid password:@"WiFi Password"];
        }
    }

    return NO;
}
@end
