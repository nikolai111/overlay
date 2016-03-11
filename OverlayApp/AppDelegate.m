//
//  AppDelegate.m
//  OverlayApp
//
//  Created by The One Tech 29 on 4/21/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize Mainurl,Userid,Dict_userAllinformation,isuploadanother,str_redirect_path;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   // Mainurl=@"http://ebiztrait.co.uk/demo/snapsyn/webservices/";
   // Mainurl=@"http://50.87.144.180/~solution/snapsyn/webservices/";
     Mainurl=@"http://snapsyn.com/webservices/";

    
    Userid=@"";
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:(255/255.0) green:(172/255.0) blue:(0/255.0) alpha:1]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];


    // Override point for customization after application launch.
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)])
    {
        // IOS 8
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
        
        self.window.contentScaleFactor = self.window.screen.nativeScale;
        NSLog(@"registro en iOS8+");
    }
    else
    {
        // Before IOS 8
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                         UIRemoteNotificationTypeAlert |
                                                         UIRemoteNotificationTypeSound)];
        NSLog(@"registro antes de iOS8");
    }
    return YES;
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    NSLog(@"My token is: %@", deviceToken);
    NSString *dToken = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    dToken = [dToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults]setObject:dToken forKey:@"Devicetoken"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
//    UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:dToken message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [Alert show];
    
    NSLog(@"STR-->%@",dToken);
}

-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Did fail to register: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSLog(@"Se recibio PUSH: %@", userInfo);
    
    UIAlertView *Alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Share Media After You Receive Notice of Ad Placement" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [Alert show];
    
//    NSString *toBeRemoved = [NSString stringWithFormat:@"%@: ", userInfo[@"sentBy"]];
//    NSString *detail = [userInfo[@"alert"][@"body"] stringByReplacingOccurrencesOfString:toBeRemoved withString:@""];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0)
    {
        NSLog(@"Path: %@", [paths objectAtIndex:0]);
        
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        // Remove Documents directory and all the files
        BOOL deleted = [fileManager removeItemAtPath:[paths objectAtIndex:0] error:&error];
        
        if (deleted != YES || error != nil)
        {
            // Deal with the error...
        }
        
    }

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([paths count] > 0)
    {
        NSLog(@"Path: %@", [paths objectAtIndex:0]);
        
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        // Remove Documents directory and all the files
        BOOL deleted = [fileManager removeItemAtPath:[paths objectAtIndex:0] error:&error];
        
        if (deleted != YES || error != nil)
        {
            // Deal with the error...
        }
        
    }

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - Show Alert
-(void)ShowAlertOnTitle:(NSString *)strTitle Message:(NSString *)strMessage
{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:strTitle message:strMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}


@end
