//
//  ChangepwdViewController.m
//  OverlayApp
//
//  Created by The One Tech 29 on 4/23/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import "ChangepwdViewController.h"
#import "AppDelegate.h"
#import "JSON.h"
@interface ChangepwdViewController ()

@end

@implementation ChangepwdViewController

- (void)viewDidLoad {
    self.navigationItem.title=@"Change Password";
    self.view.backgroundColor=[UIColor colorWithRed:(204/255.0) green:(229/255.0) blue:(255/255.0) alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:(255/255.0) green:(172/255.0) blue:(0/255.0) alpha:1] forKey:NSForegroundColorAttributeName];

    NSLog(@"%@",ApplicationDelegate.Dict_userAllinformation);
    _txt_email.text=[[ApplicationDelegate.Dict_userAllinformation objectForKey:@"email"]  objectAtIndex:0];
    [super viewDidLoad];
    _txt_email.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txt_email.layer.borderWidth=2.5;
    _txt_email.layer.cornerRadius = 10;

    _txt_oldpwd.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txt_oldpwd.layer.borderWidth=2.5;
    _txt_oldpwd.layer.cornerRadius = 10;

    _txt_newpwd.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txt_newpwd.layer.borderWidth=2.5;
    _txt_newpwd.layer.cornerRadius = 10;

    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btn_savesetting:(id)sender
{
    [self.indicator startAnimating];
    [self performSelectorInBackground:@selector(CallChangePwdWebservice) withObject:nil];

}




#pragma mark Call Webservice

-(void)CallChangePwdWebservice
{
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/webservicecpass",ApplicationDelegate.Mainurl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    [request setHTTPMethod:@"POST"];
    NSString *postData = [NSString stringWithFormat:@"email=%@&old_password=%@&new_password=%@&change_pass=1",_txt_email.text,_txt_oldpwd.text,_txt_newpwd.text];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *str=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    dict_changepwd=[str JSONValue];
    
    [self performSelectorOnMainThread:@selector(CompleteProcess) withObject:nil waitUntilDone:YES];
    
}
-(void)CompleteProcess
{
    [self.indicator stopAnimating];
    
    
    if ([[dict_changepwd objectForKey:@"response"] objectForKey:@"success"])
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict_changepwd objectForKey:@"response"] objectForKey:@"success"] objectAtIndex:0]];
        
    }
    else if ([[dict_changepwd objectForKey:@"response"] objectForKey:@"error"])
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict_changepwd objectForKey:@"response"] objectForKey:@"error"] objectAtIndex:0]];
        
    }
    
    
}


@end
