//
//  AppDelegate.h
//  OverlayApp
//
//  Created by The One Tech 29 on 4/21/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *Mainurl;
    NSString *Userid;
    NSMutableDictionary *Dict_userAllinformation;
    NSString *str_redirect_path;
    
    
    BOOL isuploadanother;
}
@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)NSString *Mainurl;
@property(strong,nonatomic)NSString *Userid;
@property(strong,nonatomic)NSMutableDictionary *Dict_userAllinformation;
@property(nonatomic,assign)BOOL isuploadanother;
@property(nonatomic,strong)NSString *str_redirect_path;
-(void)ShowAlertOnTitle:(NSString *)strTitle Message:(NSString *)strMessage;

@end

