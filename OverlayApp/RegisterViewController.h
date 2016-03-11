//
//  RegisterViewController.h
//  OverlayApp
//
//  Created by The One Tech 29 on 4/21/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>
{
    CGFloat animateDistance;
    CGFloat l;
    CGFloat lo;
    NSTimer *idleTimer;
    
    UIDatePicker* datePicker;
    NSMutableDictionary *dict_signup;
    
    
    UIPickerView *myPickerView_Payment;
    UIToolbar *toolbar_payment;
    
    NSMutableArray *Arr_PAymenttype;
    
    NSString *str_payment_id;

}
@property (strong, nonatomic) IBOutlet UIButton *button_checkmark;
@property (strong, nonatomic) IBOutlet UITextField *txt_firstname;
@property (strong, nonatomic) IBOutlet UITextField *txt_lastname;
@property (strong, nonatomic) IBOutlet UITextField *txt_email;
@property (strong, nonatomic) IBOutlet UITextField *txt_password;
@property (strong, nonatomic) IBOutlet UITextField *txt_dob;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (strong, nonatomic) IBOutlet UITextField *txt_paymenttype;
@property (strong, nonatomic) IBOutlet UITextField *txt_paymentid;
@property (strong, nonatomic) IBOutlet UIScrollView *scrl;

-(IBAction)btn_RegisterClicked:(id)sender;
- (IBAction)btn_termsandcondition:(id)sender;
- (IBAction)btn_checkmarkClicked:(id)sender;

@end
