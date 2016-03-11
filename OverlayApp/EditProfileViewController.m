//
//  RegisterViewController.m
//  OverlayApp
//
//  Created by The One Tech 29 on 4/21/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import "EditProfileViewController.h"
#import "AppDelegate.h"
#import "JSON.h"
#import "MBProgressHUD.h"



@interface EditProfileViewController ()

@end
MBProgressHUD *hud;

static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation EditProfileViewController

- (void)viewDidLoad {
    
    
    NSLog(@"%@",ApplicationDelegate.Dict_userAllinformation);

    
    self.navigationItem.title=@"Edit Profile";
    _txt_firstname.text=[[ApplicationDelegate.Dict_userAllinformation objectForKey:@"firstname"] objectAtIndex:0];
    _txt_lastname.text=[[ApplicationDelegate.Dict_userAllinformation objectForKey:@"lastname"] objectAtIndex:0];
    _txt_email.text=[[ApplicationDelegate.Dict_userAllinformation objectForKey:@"email"] objectAtIndex:0];
    _txt_paymentid.text=[[ApplicationDelegate.Dict_userAllinformation objectForKey:@"payment_id"] objectAtIndex:0];
    _txt_dob.text=[[ApplicationDelegate.Dict_userAllinformation objectForKey:@"birthdate"] objectAtIndex:0];
    _txt_password.text=[[NSUserDefaults standardUserDefaults] valueForKey:@"password"];



    self.view.backgroundColor=[UIColor colorWithRed:(204/255.0) green:(229/255.0) blue:(255/255.0) alpha:1];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:(255/255.0) green:(172/255.0) blue:(0/255.0) alpha:1] forKey:NSForegroundColorAttributeName];
    
    // Add DatePicker
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    datePicker.backgroundColor=[UIColor whiteColor];
    [_txt_dob setInputView:datePicker];
    
    // Add Toolbar
    UIToolbar *toolbar =[[UIToolbar alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,44)];
    toolbar.backgroundColor=[UIColor whiteColor];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
                                                                   target:self
                                                                   action:@selector(cancelButtonPressed:)];
    UIBarButtonItem *flexibleSpace =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                 target:self
                                                                                 action:nil];
    UIBarButtonItem *doneButton =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(doneButtonPressed:)];
    [toolbar setItems:@[cancelButton,flexibleSpace, doneButton]];
    _txt_dob.inputAccessoryView = toolbar;
    
    _scrl.contentSize=CGSizeMake(320, 700);
    
    
    [self performSelectorInBackground:@selector(CallPaymentListWebservice) withObject:nil];
    
    
    
    // Add PiCker and Toolbar For Category
    
    myPickerView_Payment = [[UIPickerView alloc] init];
    myPickerView_Payment.showsSelectionIndicator = YES;
    myPickerView_Payment.delegate = self;
    myPickerView_Payment.backgroundColor=[UIColor whiteColor];
    myPickerView_Payment.tag=103;
    myPickerView_Payment.dataSource = self;
    
    
    toolbar_payment =[[UIToolbar alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,44)];
    toolbar_payment.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *cancelButton3 = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(cancelButtonPressed_payment:)];
    
    UIBarButtonItem *flexibleSpace3 =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:self
                                                                                  action:nil];
    
    UIBarButtonItem *doneButton3 =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(doneButtonPressed_payment:)];
    [toolbar_payment setItems:@[cancelButton3,flexibleSpace3, doneButton3]];
    
    
    
    _txt_paymenttype.inputView = myPickerView_Payment;
    _txt_paymenttype.inputAccessoryView = toolbar_payment;
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.txt_firstname == textField || self.txt_lastname ==textField)
    {
        textField.text=[textField.text capitalizedString];
    }
    
    return YES;
}


-(void)viewDidAppear:(BOOL)animated
{
}
-(void)CallPaymentListWebservice
{
    
    
    NSString *appurl =[NSString stringWithFormat:@"%@/listpayment/%@",ApplicationDelegate.Mainurl,ApplicationDelegate.Userid];
    
    
    
    appurl = [appurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appurl]];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];
    NSString  *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    NSMutableDictionary *dict_Category=[returnString JSONValue];
    [self.indicator stopAnimating];
    
    [self performSelectorOnMainThread:@selector(CompleteProcess_Payment:) withObject:dict_Category waitUntilDone:YES];
}

-(void)CompleteProcess_Payment:(NSMutableDictionary *)dict
{
    NSLog(@"%@",dict);
    
    Arr_PAymenttype=[dict objectForKey:@"response"];
    
    NSLog(@"%@",[[ApplicationDelegate.Dict_userAllinformation objectForKey:@"payment_type"] objectAtIndex:0]);
    
    for (int i=0; i<[Arr_PAymenttype count]; i++)
    {
        NSString *str=[[Arr_PAymenttype objectAtIndex:i] valueForKey:@"id"];
        
        if ([str isEqualToString:[[ApplicationDelegate.Dict_userAllinformation objectForKey:@"payment_type"] objectAtIndex:0]])
        {
            _txt_paymenttype.text=[[Arr_PAymenttype objectAtIndex:i] valueForKey:@"payment_type"];
            str_payment_id=[[Arr_PAymenttype objectAtIndex:i] objectForKey:@"id"];

            break;

        }
    }
    
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark
#pragma mark Pickerview Delegate and Datasources
//picker
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //    Product *product = [arrayProduct objectAtIndex:row];
    //    nIndex = row;payment_type id
    _txt_paymenttype.text=[[Arr_PAymenttype objectAtIndex:row] objectForKey:@"payment_type"];
    str_payment_id=[[Arr_PAymenttype objectAtIndex:row] objectForKey:@"id"];
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [Arr_PAymenttype count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [[Arr_PAymenttype objectAtIndex:row] objectForKey:@"payment_type"];
}


#pragma mark Ibaction Button
-(IBAction)cancelButtonPressed_payment:(id)sender
{
    [_txt_paymenttype resignFirstResponder];
    
}
-(IBAction)doneButtonPressed_payment:(id)sender
{
    if ([_txt_paymenttype.text isEqualToString:@""])
    {
        str_payment_id=[[Arr_PAymenttype objectAtIndex:0] objectForKey:@"id"];
        _txt_paymenttype.text=[[Arr_PAymenttype objectAtIndex:0] objectForKey:@"payment_type"];
    }
    [_txt_paymenttype resignFirstResponder];
    
}

-(IBAction)cancelButtonPressed:(id)sender
{
    [_txt_dob resignFirstResponder];
    
}
-(IBAction)doneButtonPressed:(id)sender
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd"];
    
    //#################################### if date is futur than set alert ###########################################
    
    //has three possible values: NSOrderedSame,NSOrderedDescending, NSOrderedAscending
    NSDate *dateNow = [[NSDate alloc] init]; // The current date
    NSDate *startDate = dateNow;
    NSDate *endDate = [datePicker date];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |
    NSCalendarUnitDay ;
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:endDate
                                                  toDate:startDate options:0];
    NSInteger year = [components year];
    if (year>0)
    {
        _txt_dob.text = [dateformatter stringFromDate:datePicker.date];
    }
    else
    {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Alert" message:@"You Can't Choose Future date" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
        
    }
    //#################################### if date is futur than set alert ###########################################
    [_txt_dob resignFirstResponder];
    
    
    
}
-(IBAction)btn_RegisterClicked:(id)sender
{
    [self.view endEditing:YES];
    
    if (![self isValidTextField])
    {
        return;
    }
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud show:YES];
    
    
    [self.indicator startAnimating];
    [self performSelectorInBackground:@selector(CallSignupWebservice) withObject:nil];
    
}

- (IBAction)btn_termsandcondition:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://ebiztrait.co.uk/demo/snapsyn/"]];
}

#pragma mark Call Webservice

-(void)CallSignupWebservice
{
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/updateprofile",ApplicationDelegate.Mainurl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    [request setHTTPMethod:@"POST"];
    NSString *postData = [NSString stringWithFormat:@"firstname=%@&lastname=%@&password=%@&birthdate=%@&payment_type=%@&payment_id=%@&update_profile=1&user_id=%@",_txt_firstname.text,_txt_lastname.text,_txt_password.text,_txt_dob.text,str_payment_id,_txt_paymentid.text,ApplicationDelegate.Userid];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *str=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    dict_signup=[str JSONValue];
    
    [self performSelectorOnMainThread:@selector(CompleteProcess) withObject:nil waitUntilDone:YES];
    
}
-(void)CompleteProcess
{
    [self.indicator stopAnimating];
    [hud hide:YES];
    
    
    if ([[dict_signup objectForKey:@"response"] objectForKey:@"success"])
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict_signup objectForKey:@"response"] objectForKey:@"success"] objectAtIndex:0]];
        ApplicationDelegate.Dict_userAllinformation=[dict_signup objectForKey:@"profile"];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_txt_password.text forKey:@"password"];
        [defaults setObject:@"1" forKey:@"remember"];
        [defaults synchronize];
        
        
    }
    else if ([[dict_signup objectForKey:@"response"] objectForKey:@"error"])
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict_signup objectForKey:@"response"] objectForKey:@"error"] objectAtIndex:0]];
        
    }
    
    
}
#pragma mark  validation

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(BOOL)isValidTextField
{
    
    if (_txt_firstname.text.length==0)
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:@"First name should not be blank"];
        return NO;
    }
    else if (_txt_lastname.text.length==0)
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:@"Last name should not be blank"];
        return NO;
    }
    else if (_txt_email.text.length==0)
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:@"Email address should not be blank"];
        return NO;
    }
    
    else if (![self NSStringIsValidEmail:_txt_email.text])
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:@"Invalid Email address"];
        return NO;
    }
    else if (_txt_password.text.length==0)
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:@"Password should not be blank"];
        return NO;
    }
    else if (_txt_paymenttype.text.length==0)
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:@"Payment Type should not be blank"];
        return NO;
    }
    else if (_txt_paymentid.text.length==0)
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:@"Payment Id should not be blank"];
        return NO;
    }
    
    return YES;
    
}



#pragma mark Touches Events
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
}

#pragma mark TextFeild Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animateDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    [UIView commitAnimations];
    
    return YES;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textView1
{
    CGRect textFieldRect = [self.view.window convertRect:textView1.bounds fromView:textView1];
    CGRect viewRect = [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if(heightFraction < 0.0){
        
        heightFraction = 0.0;
        
    }else if(heightFraction > 1.0){
        
        heightFraction = 1.0;
    }
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown){
        
        animateDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
        
    }else{
        
        animateDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animateDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
