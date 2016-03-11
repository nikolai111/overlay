//
//  ViewController.h
//  OverlayApp
//
//  Created by The One Tech 29 on 4/21/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    
    CGFloat animateDistance;
    CGFloat l;
    CGFloat lo;
    NSTimer *idleTimer;

    
    
    NSString *emai_forgotpwd;
    NSMutableDictionary *dict_Login;
    
    
    UIDatePicker* datePicker;


}
@property (strong, nonatomic) IBOutlet UITextField *txt_email;
@property (strong, nonatomic) IBOutlet UITextField *txt_password;
@property (strong, nonatomic) IBOutlet UITextField *txt_dob;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
- (IBAction)btn_loginClicked:(id)sender;
- (IBAction)btn_forgotpwdClicked:(id)sender;


@end

