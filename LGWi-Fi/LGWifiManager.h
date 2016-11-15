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

@protocol LGWifiManagerDelegate <NSObject>
@optional
- (void)lg_ssidDidChangeToSSID:(NSString *_Nullable)ssid;
@end

@interface LGWifiManager : NSObject
+ (instancetype _Nonnull)lg_sharedManager;
- (NSSet <CWNetwork *>* _Nullable)findNetworks;
- (NSSet <NSString *>* _Nullable)findNetworksToSSID;
- (BOOL)connectWifiFromName:(NSString *_Nonnull)name password:(NSString *_Nullable)password;
- (BOOL)connectWifiWithNetwork:(CWNetwork *_Nonnull)network password:(NSString *_Nullable)password;

@property (copy, readonly, nonatomic, getter=getCurrentSSID) NSString *_Nullable currentSSID;
@property (copy, readonly, nonatomic) NSString *_Nullable errorDescription;
@property (strong, readonly, nonatomic) NSError *_Nullable error;
@property (weak, nonatomic) id<LGWifiManagerDelegate>_Nullable delegate;
@end
