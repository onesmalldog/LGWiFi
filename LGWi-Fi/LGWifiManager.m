//
//  LGWifiManager.m
//  text_Wifi
//
//  Created by 东途 on 2016/10/28.
//  Copyright © 2016年 displayten. All rights reserved.
//

#import "LGWifiManager.h"


@interface LGWifiManager() <CWEventDelegate>
@property (strong, nonatomic) CWInterface *currentInterface;
@end
@implementation LGWifiManager {
    NSError *_error;
}

- (NSString *)errorDescription {
    return _error.description;
}
- (NSError *)error {
    return _error;
}
- (NSString *)getCurrentSSID {
    return self.currentInterface.ssid;
}

+ (instancetype _Nonnull)lg_sharedManager {
    static LGWifiManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initSelf];
    });
    return manager;
}
- (NSSet <CWNetwork *>* _Nullable)findNetworks {
    
    NSError *error;
    NSSet *result;
    
    result = [self.currentInterface scanForNetworksWithSSID:nil error:&error];
    if (error) {
        _error = error;
        return nil;
    }
    return result;
}
- (NSSet <NSString *>* _Nullable)findNetworksToSSID {
    
    NSSet *find = [self findNetworks];
    if (!find) {
        return nil;
    }
    NSMutableSet *result = [NSMutableSet set];
    for (CWNetwork *network in find) {
        [result addObject:network.ssid];
    }
    return result;
}
- (BOOL)connectWifiFromName:(NSString *_Nonnull)name password:(NSString *_Nullable)password {
    
    NSSet *set = [self.currentInterface cachedScanResults];
    for (CWNetwork *network in set) {
        NSString *searchName = network.ssid;
        if ([searchName isEqualToString:name]) {
            return [self connectWifiWithNetwork:network password:password];
        }
    }
    for (CWNetwork *network in [self findNetworks]) {
        NSString *searchName = network.ssid;
        if ([searchName isEqualToString:name]) {
            return [self connectWifiWithNetwork:network password:password];
        }
    }
    return NO;
}

- (BOOL)connectWifiWithNetwork:(CWNetwork *_Nonnull)network password:(NSString *_Nullable)password  {
    
    NSError *error;
    BOOL result = [self.currentInterface associateToNetwork:network password:password error:&error];
    
    if (!result) {
        _error = error;
    }
    return result;
}

- (instancetype)initSelf {
    if (self = [super init]) {
        
        CWInterface *defaultInterface = [CWWiFiClient sharedWiFiClient].interface;
        
        [CWWiFiClient sharedWiFiClient].delegate = self;
        BOOL result = [[CWWiFiClient sharedWiFiClient] startMonitoringEventWithType:CWEventTypeSSIDDidChange error:nil];
        if (result) {
            
        }
        NSString *name = defaultInterface.interfaceName;
        if (defaultInterface && name) {
            
            self.currentInterface = defaultInterface;
        }
        else {
            NSArray <NSString *>*names = [CWWiFiClient interfaceNames];
            if (names.count>=1 && [names containsObject:@"en1"]) {
                self.currentInterface = [[CWWiFiClient alloc] interfaceWithName:@"en1"];
            }
        }
    }
    return self;
}

- (void)ssidDidChangeForWiFiInterfaceWithName:(NSString *)interfaceName {
    if ([self.delegate respondsToSelector:@selector(lg_ssidDidChangeToSSID:)]) {
        [self.delegate lg_ssidDidChangeToSSID:self.currentSSID];
    }
}
@end
