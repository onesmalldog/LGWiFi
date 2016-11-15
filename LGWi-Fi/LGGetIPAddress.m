//
//  LGGetIPAddress.m
//  text_Wifi
//
//  Created by 东途 on 2016/11/3.
//  Copyright © 2016年 displayten. All rights reserved.
//

#import "LGGetIPAddress.h"
#include <ifaddrs.h>
#include <sys/socket.h>
#include <arpa/inet.h>

@implementation LGGetIPAddress

+ (NSString *)getIP {
    return [self getIPAddress];
}
+ (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
//            unsigned char a = ;
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
//                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
//                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}
@end
