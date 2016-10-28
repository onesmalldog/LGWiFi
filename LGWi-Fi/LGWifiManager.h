//
//  LGWifiManager.h
//  text_Wifi
//
//  Created by 东途 on 2016/10/28.
//  Copyright © 2016年 displayten. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreWLAN/CoreWLAN.h>

#define LGWiFi [LGWifiManager lg_sharedManager]
@interface LGWifiManager : NSObject
+ (instancetype _Nonnull)lg_sharedManager;
- (NSSet <CWNetwork *>* _Nullable)findNetworks;
- (NSSet <NSString *>* _Nullable)findNetworksToSSID;
- (BOOL)connectWifiFromName:(NSString *_Nonnull)name password:(NSString *_Nullable)password;
- (BOOL)connectWifiWithNetwork:(CWNetwork *_Nonnull)network password:(NSString *_Nullable)password ;
@end
