//
//  ChangepwdViewController.h
//  OverlayApp
//
//  Created by The One Tech 29 on 4/23/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangepwdViewController : UIViewController
{
    NSMutableDictionary *dict_changepwd;
}
@property (strong, nonatomic) IBOutlet UITextField *txt_email;
@property (strong, nonatomic) IBOutlet UITextField *txt_oldpwd;
@property (strong, nonatomic) IBOutlet UITextField *txt_newpwd;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
- (IBAction)btn_savesetting:(id)sender;

@end
