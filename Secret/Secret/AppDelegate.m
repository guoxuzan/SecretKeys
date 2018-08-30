//
//  AppDelegate.m
//  Secret
//
//  Created by 郭旭赞 on 2017/1/8.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LocalAuthenticationViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "Header.h"

@interface AppDelegate ()

@property (nonatomic,strong) ViewController *vc;
@property (nonatomic,strong) LocalAuthenticationViewController *localAuthenticationVC;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = kBackgroundColor;
    [self.window makeKeyAndVisible];
    
    LAContext *context = [LAContext new];
    NSError *error;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:kTouchIDSwitch]) {
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:kTouchIDSwitch];
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:kTouchIDSwitch];
        }
        [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:kPasswordSwitch];
        
//        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//        pasteboard.string = NSLocalizedString(@"pasteboardInitString", nil);
        
        NSMutableDictionary *itemDic0 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"itemDic0Title", nil),kTitle,NSLocalizedString(@"itemDic0Content", nil),kContent, nil];
        NSMutableDictionary *itemDic1 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"itemDic1Title", nil),kTitle,NSLocalizedString(@"itemDic1Content", nil),kContent, nil];
        NSMutableDictionary *itemDic2 = [[NSMutableDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"itemDic2Title", nil),kTitle,@"",kContent, nil];
        NSMutableArray *itemArray = [[NSMutableArray alloc] initWithObjects:itemDic0,itemDic1,itemDic2,nil];
        NSMutableArray *initArray = [[NSMutableArray alloc] initWithObjects:itemArray, nil];
        [[NSUserDefaults standardUserDefaults] setObject:initArray forKey:@"SecretData"];
    }else {
        if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:kTouchIDSwitch] boolValue]) {
                
            }else {
                [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:kTouchIDSwitch];
            }
        }else {
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:kTouchIDSwitch];
        }
    }
    
    self.vc = [ViewController new];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:self.vc];
    [nc.navigationBar setTitleTextAttributes:@{
                                               NSForegroundColorAttributeName:[UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1.0],
                                               NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
                                               }];
    self.window.rootViewController = nc;
    
    [self localAuthentication];
    
    return YES;
}

- (void)localAuthentication {
    BOOL isTouchID = [[[NSUserDefaults standardUserDefaults] objectForKey:kTouchIDSwitch] boolValue];
    BOOL isPassword = [[[NSUserDefaults standardUserDefaults] objectForKey:kPasswordSwitch] boolValue];
    
    if ((!isTouchID) && (!isPassword)) {
        return;
    }else {
        self.localAuthenticationVC = [LocalAuthenticationViewController new];
        self.localAuthenticationVC.isTouchID = isTouchID;
        self.localAuthenticationVC.isPassword = isPassword;
        [self.vc presentViewController:self.localAuthenticationVC animated:NO completion:^{
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:UIPasteboardChangedNotification object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
