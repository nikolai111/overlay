//
//  VideoViewViewController.m
//  OverlayApp
//
//  Created by The One Tech 29 on 4/28/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import "VideoViewViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "EditVideoViewController.h"
#import "MBProgressHUD.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "SocialVideoHelper.h"
@interface VideoViewViewController ()
{
    NSURL *requestURL;
    int result;
    ACAccount *twitterAccount;
}

@end
MBProgressHUD *hud;
@implementation VideoViewViewController
@synthesize dict_VideoAlldetails;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
  self.view.backgroundColor=[UIColor colorWithRed:(204/255.0) green:(229/255.0) blue:(255/255.0) alpha:1];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:(255/255.0) green:(172/255.0) blue:(0/255.0) alpha:1] forKey:NSForegroundColorAttributeName];

    _lbl_title.text=[dict_VideoAlldetails objectForKey:@"title"];
    _lbl_category.text=[dict_VideoAlldetails objectForKey:@"category"];
    self.navigationItem.title=[dict_VideoAlldetails objectForKey:@"title"];
    
    if ([[dict_VideoAlldetails objectForKey:@"type"] isEqualToString:@"image"])
    {
        UIImageView *imageview_Overlay=[[UIImageView alloc] init];
        if ([[dict_VideoAlldetails objectForKey:@"overlay"] isEqualToString:@"Top"])
        {
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            CGFloat screenHeight = screenRect.size.height;
            NSLog(@"%f",screenWidth);
            if (screenWidth<321) {
              imageview_Overlay.frame=CGRectMake(0, 0, _imge_thumb.frame.size.width, 40);
            }else{
            imageview_Overlay.frame=CGRectMake(0, 0, _imge_thumb.frame.size.width+60, 40);
            }
                imageview_Overlay.image=[UIImage imageNamed:@"banner.png"];

        }
        else
        {
            imageview_Overlay.frame=CGRectMake(0, 0, _imge_thumb.frame.size.width/2-40, _imge_thumb.frame.size.width/2-40);
            imageview_Overlay.image=[UIImage imageNamed:@"logo-left.png"];
             UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap)];
            [imageview_Overlay setUserInteractionEnabled:YES];
            [imageview_Overlay addGestureRecognizer:singleTap];


        }
       // imageview_Overlay.contentMode=UIViewContentModeScaleAspectFit;
        imageview_Overlay.backgroundColor=[UIColor clearColor];

       // [_imge_thumb addSubview:imageview_Overlay];
        _imge_thumb.userInteractionEnabled=YES;
        [_imge_thumb setImageWithURL:[NSURL URLWithString:[dict_VideoAlldetails objectForKey:@"path"]] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        
        NSLog(@"%f,%f", _imge_thumb.bounds.size.width, _imge_thumb.bounds.size.height);
    }
    else
    {
        [self PlayVideo];
    }
    
    // Do any additional setup after loading the view.
}

-(void)ShowHudd
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud show:YES];
}
- (void) getInfo
{
    // Request access to the Twitter accounts
    
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error){
        if (granted) {
            
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            
            // Check if the users has setup at least one Twitter account
            
            if (accounts.count > 0)
            {
                [self performSelectorOnMainThread:@selector(ShowHudd) withObject:nil waitUntilDone:YES];
                twitterAccount = [accounts objectAtIndex:0];
                [self ShareVideoontwitter];
                // Creating a request to get the info about a user on Twitter
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Please configure Twitter in Settings!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        } else {
            NSLog(@"No access granted");
        }
    }];
}

-(void)oneTap
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://ebiztrait.co.uk/demo/snapsyn/"]];

}
-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark
#pragma mark PlayVideo Functions
-(void)PlayVideo
{
    NSLog(@"%f",self.view.frame.size.height);
    
    NSURL *url = [NSURL URLWithString:[dict_VideoAlldetails objectForKey:@"path"]];
    
    //初始化播放器
    mpcontroller = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    //把播放器的视图添加到当前视图下（作为子视图）
    [self.view addSubview:mpcontroller.view];
    
    
    if (self.view.frame.size.height==667)
    {
        mpcontroller.view.frame = CGRectMake(self.imge_thumb.frame.origin.x,self.imge_thumb.frame.origin.y,325,254);
        
    }
    else if (self.view.frame.size.height==736)
    {
        mpcontroller.view.frame = CGRectMake(self.imge_thumb.frame.origin.x,self.imge_thumb.frame.origin.y,364,254);
        
    }
    else
    {
        mpcontroller.view.frame = CGRectMake(self.imge_thumb.frame.origin.x,self.imge_thumb.frame.origin.y,270,254);
        
    }
    
    //设置frame，让它显示在屏幕上，分别是X,Y，宽度和高度，你可以调整
    //  [mpcontroller.view setTransform:CGAffineTransformMakeRotation(90.0f*(M_PI/180.0f))];
    
    //设置电影结束后的回调方法，方法名为：callbackFunction，注册自己为observer
    //当MPMoviePlayerPlaybackDidFinishNotification事件发生时，就调用指定的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callbackFunction:) name:MPMoviePlayerPlaybackDidFinishNotification object:mpcontroller];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mpplayBackStateChange:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:mpcontroller];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedPlaying:) name:MPMoviePlayerLoadStateDidChangeNotification object:mpcontroller];
    /* [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedPlaying:) name:MPMoviePlayerLoadStateDidChangeNotification object:mpcontroller];*/
    //设置播放器的一些属性
    mpcontroller.fullscreen = YES;
   // mpcontroller.shouldAutoplay=YES;
    mpcontroller.scalingMode = MPMovieScalingModeAspectFill;
    NSLog(@"%f",mpcontroller.duration);
    
    
    
    
    
    UIImageView *imageview_Overlay=[[UIImageView alloc] init];
    if ([[dict_VideoAlldetails objectForKey:@"overlay"] isEqualToString:@"Top"])
    {
        imageview_Overlay.frame=CGRectMake(0, 0, mpcontroller.view.frame.size.width, 40);
        imageview_Overlay.image=[UIImage imageNamed:@"banner.png"];
    }
    else
    {
        imageview_Overlay.frame=CGRectMake(0, 0, _imge_thumb.frame.size.width/2-40, _imge_thumb.frame.size.width/2-40);
        imageview_Overlay.image=[UIImage imageNamed:@"logo-left.png"];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(oneTap)];
        [imageview_Overlay setUserInteractionEnabled:YES];
        [imageview_Overlay addGestureRecognizer:singleTap];

        imgInstance=imageview_Overlay;

        
    }
    imageview_Overlay.backgroundColor=[UIColor clearColor];
    //imageview_Overlay.contentMode=UIViewContentModeScaleAspectFit;
    [mpcontroller.view addSubview:imageview_Overlay];

    
    //播放电影
    [mpcontroller play];
    
}
-(void)mpplayBackStateChange:(NSNotification *)notification
{
    NSLog(@"%@",notification);
     MPMoviePlayerController *video = [notification object];
    NSLog(@"%d",video.playbackState);
    if (video.playbackState ==MPMoviePlaybackStateStopped||video.playbackState ==MPMoviePlaybackStatePaused)
    {
         imgInstance.hidden=NO;
    }
    else
    {
        imgInstance.hidden=NO;
        [self ControlPlayerForInterVal:video];
    }

    
}
-(void)ControlPlayerForInterVal:(MPMoviePlayerController *)video
{
    if (video.duration>4)
    {
        [self performSelector:@selector(methodToHideAd) withObject:nil afterDelay:4.0];

//        float hideAfter=(20*video.duration)/100;
//        if (hideAfter>2)
//        {
//            [self performSelector:@selector(methodToHideAd) withObject:nil afterDelay:hideAfter];
//        }
    }
    
}
-(void)startedPlaying:(NSNotification *)notification
{
 MPMoviePlayerController *video = [notification object];
    NSLog(@"%f",video.duration);
    
    [self ControlPlayerForInterVal:video];
}
-(void)methodToHideAd
{
    imgInstance.hidden=YES;
}
- (void) callbackFunction: (NSNotification*) notification
{
   /* MPMoviePlayerController *video = [notification object];
    //从通知中心注销自己
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification object:video];*/
    //[self methodToHideAd];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark
#pragma mark IBAction Of button

- (IBAction)btn_editClicked:(id)sender {
    
    [self performSegueWithIdentifier:@"Editvideo" sender:nil];
    
}

- (IBAction)btn_deleteClicked:(id)sender {
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Are you sure you want to delete this media?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
}
- (IBAction)btn_shareClicked:(id)sender {
    
    [self.indicator startAnimating];
    [self performSelectorInBackground:@selector(CallSharingWebservice) withObject:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    NSLog(@"tes");
   // [mpcontroller stop];
    [super viewDidDisappear:animated];
}


#pragma mark
#pragma mark Alertview Delegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        NSLog(@"yes");
        [self.indicator startAnimating];
        [self performSelectorInBackground:@selector(CallDeleteWebservice) withObject:nil];
        
    }
}

#pragma mark Call Webservices

-(void)CallDeleteWebservice
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/webserviceudeletemedia",ApplicationDelegate.Mainurl]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[url standardizedURL]];
    [request setHTTPMethod:@"POST"];
    NSString *postData = [NSString stringWithFormat:@"user_id=%@&media_id=%@&submit=1",ApplicationDelegate.Userid,[dict_VideoAlldetails objectForKey:@"id"]];
    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //set post data of request
    [request setHTTPBody:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    NSError *error;
    NSURLResponse *response;
    NSData *urlData=[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSString *str=[[NSString alloc]initWithData:urlData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict_Login=[str JSONValue];
    [self performSelectorOnMainThread:@selector(CompleteProcess:) withObject:dict_Login waitUntilDone:YES];
    
}
-(void)CompleteProcess:(NSMutableDictionary *)dict
{
    [self.indicator stopAnimating];
    [ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict objectForKey:@"response"] objectForKey:@"success"] objectAtIndex:0]];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}



-(void)test
{
    
}

-(void)CallSharingWebservice
{
    
    NSString *appurl =[NSString stringWithFormat:@"%@/webserviceshare/%@",ApplicationDelegate.Mainurl,[dict_VideoAlldetails objectForKey:@"id"]];
//     NSString *appurl =[NSString stringWithFormat:@"%@/webserviceshare/%@",ApplicationDelegate.Mainurl,@"611"];
    appurl = [appurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appurl]];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];
    NSString  *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    NSMutableDictionary *dict=[returnString JSONValue];
    [self performSelectorOnMainThread:@selector(CompleteProcess_Sharing:) withObject:dict waitUntilDone:YES];
    
}
-(void)CompleteProcess_Sharing:(NSMutableDictionary *)dict
{
    if ([[dict objectForKey:@"response"] objectForKey:@"success"])
    {
        Dict_ShareUrl=[dict copy];
        
        
        UIActionSheet *actionSheet;
        
        if (_imge_thumb.image==nil)
        {
            actionSheet = [[UIActionSheet alloc] initWithTitle:Nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share to Instagram",@"Share Directly",@"Share to Vine",@"Share to Twitter", nil];
            actionSheet.tag=1001;
        }
        else
        {
            actionSheet = [[UIActionSheet alloc] initWithTitle:Nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share to Instagram",@"Share Directly",@"Share to Twitter", nil];
            actionSheet.tag=1002;
        }
        
        actionSheet.delegate=self;
        [actionSheet showInView:self.view];
    }
    else if ([[dict objectForKey:@"response"] objectForKey:@"error"])
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict objectForKey:@"response"] objectForKey:@"error"] objectAtIndex:0]];
        
    }
    [self.indicator stopAnimating];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag==1002)
    {
        if (buttonIndex==0)
        {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            [hud show:YES];
            
            [self performSelector:@selector(shareInInstagram) withObject:nil afterDelay:0.1];
        }
        else if (buttonIndex==1)
        {
            NSString *text = [dict_VideoAlldetails objectForKey:@"title"];
            NSURL *url = [NSURL URLWithString:[[[Dict_ShareUrl objectForKey:@"response"] objectForKey:@"success"] objectAtIndex:0]];
            
            UIActivityViewController *controller =
            [[UIActivityViewController alloc]
             initWithActivityItems:@[text, url]
             applicationActivities:nil];
            
            [self presentViewController:controller animated:YES completion:nil];
        }
        else if (buttonIndex==2)
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
                [tweetSheet setInitialText:[NSString stringWithFormat: @"@%@ ", [dict_VideoAlldetails objectForKey:@"title"]]];
                NSLog(@"%f, %f", _imge_thumb.bounds.size.width, _imge_thumb.bounds.size.height);
                
                [tweetSheet addImage:_imge_thumb.image];
                [self presentViewController:tweetSheet animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Please configure Twitter in Settings!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }
    }
    else
    {
        if (buttonIndex==0)
        {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            [hud show:YES];

            [self performSelector:@selector(ShareVideoonInstagram) withObject:nil afterDelay:0.1];
        }

       else if (buttonIndex==1)
        {
            NSString *text = [dict_VideoAlldetails objectForKey:@"title"];
            NSURL *url = [NSURL URLWithString:[[[Dict_ShareUrl objectForKey:@"response"] objectForKey:@"success"] objectAtIndex:0]];
            
            UIActivityViewController *controller =
            [[UIActivityViewController alloc]
             initWithActivityItems:@[text, url]
             applicationActivities:nil];
            
            [self presentViewController:controller animated:YES completion:nil];
        }
        else if (buttonIndex==2)
        {
            hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeIndeterminate;
            [hud show:YES];
            [self performSelector:@selector(ShareVideotoOther) withObject:nil afterDelay:0.1];
        }
        else if (buttonIndex==3)
        {
            if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
                
                SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//                [tweetSheet setInitialText:[NSString stringWithFormat: @"@%@ ", [dict_VideoAlldetails objectForKey:@"title"]]];
//                [tweetSheet addURL:[NSURL URLWithString:[dict_VideoAlldetails objectForKey:@"path"]]];
                [self getInfo];
                //[self presentViewController:tweetSheet animated:YES completion:nil];
            }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error!" message:@"Please configure Twitter in Settings!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
                
            }
        }

        
    }
}

-(void)ShareVideoontwitter
{
    NSString *videoUrl = [dict_VideoAlldetails objectForKey:@"path"];
    NSLog(@"found a video");
    
    // Code To give Name to video and store to DocumentDirectory //
    
    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoUrl]];
    
    float size= (float)videoData.length/1024.0f/1024.0f;
    NSLog(@"Size-->%f",size);

    if(size<=12.0)
    {
        [SocialVideoHelper uploadTwitterVideo:videoData account:twitterAccount withCompletion:^{
            
            NSLog(@"Success");
            [self performSelectorOnMainThread:@selector(HideHudd) withObject:nil waitUntilDone:YES];
        }];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(HideHudd) withObject:nil waitUntilDone:YES];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Video Size Exceeded Limit" message:@"You have exceeded max video upload size of Twitter" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    }
    
   
}
-(void)HideHudd
{
    [hud hide:YES];
}

-(void)ShareVideoonInstagram
{
    NSString *videoUrl = [dict_VideoAlldetails objectForKey:@"path"];
    NSLog(@"found a video");
    
    // Code To give Name to video and store to DocumentDirectory //
    
    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoUrl]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
    [dateFormat setDateFormat:@"dd-MM-yyyy-HH:mm:SS"];
    NSDate *now = [[NSDate alloc] init] ;
    NSString *theDate = [dateFormat stringFromDate:now];

    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Default Album"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *videopath= [NSString stringWithFormat:@"%@/%@.MOV",documentsDirectory,theDate]; ;
    
    BOOL success = [videoData writeToFile:videopath atomically:YES];
    
    NSLog(@"Successs:::: %@", success ? @"YES" : @"NO");
    NSLog(@"video path --> %@",videopath);

    
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    NSURL *videoURL = [NSURL URLWithString:videopath];
    
    if (videoURL != nil)
    {
        [hud hide:YES];

        [assetsLibrary
         writeVideoAtPathToSavedPhotosAlbum:videoURL
         completionBlock:^(NSURL *assetURL, NSError *error)
        {
             NSString *escapedCaption  = [self urlencodedString:[dict_VideoAlldetails objectForKey:@"title"]];
             NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:[@"instagram://library?AssetPath=%@&InstagramCaption=%@" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],assetURL.absoluteString,escapedCaption]];
             if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
             {
                 [[UIApplication sharedApplication] openURL:instagramURL];
             }
         }];
    }
    else
    {
        [hud hide:YES];
        NSLog(@"Could not find the video in the app bundle.");
    }
}


-(void)ShareVideotoOther
{
    NSString *videoUrl = [dict_VideoAlldetails objectForKey:@"path"];
    
    NSLog(@"found a video");
    
    
    // Code To give Name to video and store to DocumentDirectory //
    
    NSData *videoData = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoUrl]];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init] ;
    [dateFormat setDateFormat:@"dd-MM-yyyy-HH:mm:SS"];
    NSDate *now = [[NSDate alloc] init] ;
    NSString *theDate = [dateFormat stringFromDate:now];
    
    
    NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Default Album"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
    
    NSString *videopath= [NSString stringWithFormat:@"%@/%@.MOV",documentsDirectory,theDate]; ;
    
    BOOL success = [videoData writeToFile:videopath atomically:YES];
    
    NSLog(@"Successs:::: %@", success ? @"YES" : @"NO");
    NSLog(@"video path --> %@",videopath);
    
    
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    
    NSURL *videoURL = [NSURL URLWithString:videopath];
    
    if (videoURL != nil){
        [hud hide:YES];
        
        [assetsLibrary
         writeVideoAtPathToSavedPhotosAlbum:videoURL
         completionBlock:^(NSURL *assetURL, NSError *error) {
             
             NSArray *objectsToShare = [NSArray arrayWithObjects: assetURL, nil];
             UIActivityViewController *yourvc = [[UIActivityViewController alloc]initWithActivityItems:objectsToShare applicationActivities:[NSArray arrayWithObjects:nil]];
             [self presentModalViewController:yourvc animated:YES];
          
         }];
    }
    else
    {
        [hud hide:YES];
        NSLog(@"Could not find the video in the app bundle.");
    }
}



-(NSString*)urlencodedString:(NSString*)theStr
{
    return [theStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (BOOL)openVideoPath:(NSString*)assetPathString withCaption:(NSString*)caption
{
    if(![self isInstalled])
    {
        return NO;
    }
    NSString *escapedAssetPathString = [assetPathString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    NSString *escapedCaption = [caption stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    NSLog(@"[INFO] openVideoPath : escapedAssetPathString : %@", escapedAssetPathString);
    
    NSLog(@"[INFO] openVideoPath : escapedCaption : %@", escapedCaption);
    
    
    NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?AssetPath=%@&InstagramCaption=%@", escapedAssetPathString, escapedCaption]];
    
    [[UIApplication sharedApplication] openURL:instagramURL];
    
    return YES;
}
- (BOOL)isInstalled
{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
    
    if (![[UIApplication sharedApplication] canOpenURL:instagramURL])
    {
        return NO;
    }
    
    return YES;
}



-(void)shareInInstagram
{
    
    //NSString *imgurl = [dict_VideoAlldetails objectForKey:@"share_instagram"];
    NSString *imgurl = [dict_VideoAlldetails objectForKey:@"share_instagram"];

    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgurl]];

    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
    
    NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
    
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]]; //add our image to the path
    
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
    
    NSLog(@"image saved");
    
    
    CGRect rect = CGRectMake(0 ,0 , 0, 0);
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIGraphicsEndImageContext();
    NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
    NSLog(@"jpg path %@",jpgPath);
    NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath]; //[[NSString alloc] initWithFormat:@"file://%@", jpgPath] ];
    NSLog(@"with File path %@",newJpgPath);
    NSURL *igImageHookFile = [NSURL URLWithString:newJpgPath];
    NSLog(@"url Path %@",igImageHookFile);
    
    self.dic.UTI = @"com.instagram.exclusivegram";
    self.dic = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
    self.dic=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
    [self.dic presentOpenInMenuFromRect: rect    inView: self.view animated: YES ];
    [hud hide:YES];

    
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL usingDelegate: (id <UIDocumentInteractionControllerDelegate>) interactionDelegate {
    NSLog(@"file url %@",fileURL);
    UIDocumentInteractionController *interactionController = [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    interactionController.delegate = interactionDelegate;
    
    return interactionController;
}

#pragma mark
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Editvideo"])
    {
        EditVideoViewController *obj=(EditVideoViewController *)[segue destinationViewController];
        obj.dict_VideoAlldetails=dict_VideoAlldetails;
    }
}




@end
