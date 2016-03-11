//
//  ViewController.m
//  OverlayApp
//
//  Created by The One Tech 29 on 4/21/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "JSON.h"

@interface ViewController ()


@end


static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

@implementation ViewController

- (void)viewDidLoad
{
    self.navigationItem.title=@"Login";
    self.view.backgroundColor=[UIColor colorWithRed:(204/255.0) green:(229/255.0) blue:(255/255.0) alpha:1];
    // Add DatePicker
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:(255/255.0) green:(172/255.0) blue:(0/255.0) alpha:1] forKey:NSForegroundColorAttributeName];

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
    

    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if([[defaults objectForKey:@"remember"]isEqualToString:@"1"])
    {
        _txt_email.text=[defaults objectForKey:@"email"];
        _txt_password.text=[defaults objectForKey:@"password"];

        [self.indicator startAnimating];
        [self performSelectorInBackground:@selector(CallLoginpWebservice) withObject:nil];
    }
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark IBaction of button

-(IBAction)cancelButtonPressed:(id)sender
{
    [_txt_dob resignFirstResponder];
    
}
-(IBAction)doneButtonPressed:(id)sender
{
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM/dd/yyyy"];
    
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

- (IBAction)btn_loginClicked:(id)sender {
    
//    if (![self isValidTextField])
//    {
//        return;
//    }
    [self.view endEditing:YES];

    [self.indicator startAnimating];
    [self performSelectorInBackground:@selector(CallLoginpWebservice) withObject:nil];
}

- (IBAction)btn_forgotpwdClicked:(id)sender
{
    [self.view endEditing:YES];

    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Enter Your Email Address" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

#pragma mark Call Webservices

-(void)CallLoginpWebservice
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/webservicelogin",ApplicationDelegate.Mainurl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    [request setHTTPMethod:@"POST"];
    
    NSString *Str_Token=[[NSUserDefaults standardUserDefaults]objectForKey:@"Devicetoken"];

    NSString *postData;
    if (Str_Token.length==0)
    {
         postData = [NSString stringWithFormat:@"email=%@&password=%@&birthdate=%@&login=1",_txt_email.text,_txt_password.text,_txt_dob.text];
    }
    else
    {
         postData = [NSString stringWithFormat:@"email=%@&password=%@&birthdate=%@&devicetoken=%@&login=1",_txt_email.text,_txt_password.text,_txt_dob.text,Str_Token];
    }
    
   
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *str=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    dict_Login=[str JSONValue];
    [self performSelectorOnMainThread:@selector(CompleteProcess) withObject:nil waitUntilDone:YES];
    
}
-(void)CallForgotPwdWebservices
{
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/webservicefpass",ApplicationDelegate.Mainurl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    [request setHTTPMethod:@"POST"];
    NSString *postData = [NSString stringWithFormat:@"email=%@&forgot_pass=1",emai_forgotpwd];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *str=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    dict_Login=[str JSONValue];
    [self performSelectorOnMainThread:@selector(CompleteProcess_forgot) withObject:nil waitUntilDone:YES];
    
    
}
-(void)CompleteProcess_forgot
{
    [self.indicator stopAnimating];
    
    if ([[dict_Login objectForKey:@"response"] objectForKey:@"success"])
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict_Login objectForKey:@"response"] objectForKey:@"success"] objectAtIndex:0]];
//        ApplicationDelegate.Dict_userAllinformation=[dict_Login objectForKey:@"profile"];
//        ApplicationDelegate.Userid=[[[dict_Login objectForKey:@"profile"] objectForKey:@"id"] objectAtIndex:0];
//        
//        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        [defaults setObject:_txt_email.text forKey:@"email"];
//        [defaults setObject:_txt_password.text forKey:@"password"];
//        [defaults setObject:@"1" forKey:@"remember"];
//        [defaults synchronize];
//        
//        
//        [self performSegueWithIdentifier:@"VideoList" sender:nil];
        
    }
    else if ([[dict_Login objectForKey:@"response"] objectForKey:@"error"])
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict_Login objectForKey:@"response"] objectForKey:@"error"] objectAtIndex:0]];
        
    }

}

-(void)CompleteProcess
{
    [self.indicator stopAnimating];

    if ([[dict_Login objectForKey:@"response"] objectForKey:@"success"])
    {
        //[ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict_Login objectForKey:@"response"] objectForKey:@"success"] objectAtIndex:0]];
        ApplicationDelegate.Dict_userAllinformation=[dict_Login objectForKey:@"profile"];
        ApplicationDelegate.Userid=[[[dict_Login objectForKey:@"profile"] objectForKey:@"id"] objectAtIndex:0];
        
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_txt_email.text forKey:@"email"];
        [defaults setObject:_txt_password.text forKey:@"password"];
        [defaults setObject:@"1" forKey:@"remember"];
        [defaults synchronize];


        [self performSegueWithIdentifier:@"VideoList" sender:nil];
        
    }
    else if ([[dict_Login objectForKey:@"response"] objectForKey:@"error"])
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict_Login objectForKey:@"response"] objectForKey:@"error"] objectAtIndex:0]];
        
    }
    

}

#pragma mark Alertview Deleget
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        emai_forgotpwd = [[alertView textFieldAtIndex:0] text];
         if (![self NSStringIsValidEmail:emai_forgotpwd])
        {
            [ApplicationDelegate ShowAlertOnTitle:nil Message:@"Invalid Email address"];
        }
        else
        {
            [self.indicator startAnimating];
            [self performSelectorInBackground:@selector(CallForgotPwdWebservices) withObject:nil];
        }
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    emai_forgotpwd = [[alertView textFieldAtIndex:0] text];
    if( [emai_forgotpwd length] >= 1 )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
#pragma mark validation
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
    
    if (_txt_email.text.length==0)
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:@"Email address should not be blank"];
        return NO;
    }
    else if (_txt_password.text.length==0)
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:@"Password should not be blank"];
        return NO;
    }
    
    else if (![self NSStringIsValidEmail:_txt_email.text])
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:@"Invalid Email address"];
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




@end
