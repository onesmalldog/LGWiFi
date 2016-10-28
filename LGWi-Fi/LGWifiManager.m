//
//  LGWifiManager.m
//  text_Wifi
//
//  Created by 东途 on 2016/10/28.
//  Copyright © 2016年 displayten. All rights reserved.
//

#import "LGWifiManager.h"


@interface LGWifiManager()
@property (strong, nonatomic) CWInterface *currentInterface;
@end
@implementation LGWifiManager {
    dispatch_queue_t _waitQueue;
    NSString *_currentWifiSSID;
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
        NSLog(@"Error: %@", error.localizedDescription);
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
    if (!_waitQueue) _waitQueue = dispatch_queue_create("waitingforconnection", DISPATCH_QUEUE_SERIAL);
    BOOL result = [self.currentInterface associateToNetwork:network password:password error:&error];
    if (result) {
        _currentWifiSSID = network.ssid;
    }
    return result;
}

- (instancetype)initSelf {
    if (self = [super init]) {
        
        CWInterface *defaultInterface = [CWWiFiClient sharedWiFiClient].interface;
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
@end
