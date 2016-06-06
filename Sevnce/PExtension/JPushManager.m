////
////  JPushManager.m
////  JMS
////
////  Created by crly on 15/8/29.
////  Copyright (c) 2015年 sevnce. All rights reserved.
////
//
//#import "JPushManager.h"
//#import "JPUSHService.h"
//
//
//#define APPKEY @"dc3573e40da9fbbbef68351b" //应用key
//#define CHNNEL @"Publish channel"
//
//@implementation JPushManager
//
//+ (void)setupWithOptions:(NSDictionary *)launchOptions {
//    // Required
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
//    // ios8之后可以自定义category
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        // 可以添加自定义categories
//        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
//                                                          UIUserNotificationTypeSound |
//                                                          UIUserNotificationTypeAlert)
//                                              categories:nil];
//        
//    } else {
//#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_8_0
//        // ios8之前 categories 必须为nil
//        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                          UIRemoteNotificationTypeSound |
//                                                          UIRemoteNotificationTypeAlert)
//                                              categories:nil];
//#endif
//    }
//#else
//    // categories 必须为nil
//    [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                      UIRemoteNotificationTypeSound |
//                                                      UIRemoteNotificationTypeAlert)
//                                          categories:nil];
//#endif
//    
//    // Required
////    [JPUSHService setupWithOption:launchOptions];
//    [JPUSHService setupWithOption:launchOptions appKey:APPKEY channel:CHNNEL apsForProduction:NO]; //production为no代表开发环境yes则为正式环境
//    return;
//}
//
//+ (void)registerDeviceToken:(NSData *)deviceToken {
//    [JPUSHService registerDeviceToken:deviceToken];
//    return;
//}
//
//+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion {
//    [JPUSHService handleRemoteNotification:userInfo];
//    
//    if (completion) {
//        completion(UIBackgroundFetchResultNewData);
//    }
//    return;
//}
//
//+ (void)showLocalNotificationAtFront:(UILocalNotification *)notification {
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
//    return;  
//}
//
//@end
