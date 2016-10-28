//
//  CWNetwork+Extension.m
//  text_Wifi
//
//  Created by 东途 on 2016/10/28.
//  Copyright © 2016年 displayten. All rights reserved.
//

#import "CWNetwork+Extension.h"
#import "LGWifiManager.h"
@implementation CWNetwork (Extension)

- (BOOL)connectToThisNetworkWithPassword:(NSString *_Nullable)password {
    return [LGWiFi connectWifiWithNetwork:self password:password];
}

@end
