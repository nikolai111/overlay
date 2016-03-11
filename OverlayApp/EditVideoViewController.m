//
//  HomeViewController.m
//  OverlayApp
//
//  Created by The One Tech 29 on 4/23/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import "EditVideoViewController.h"
#import "JSON.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "VideoListViewController.h"
#import "MBProgressHUD.h"


#define kStartTag   @"--%@\r\n"
#define kEndTag     @"\r\n"
#define kContent    @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define kBoundary   @"---------------------------14737809831466499882746641449"
@interface EditVideoViewController ()

@end
MBProgressHUD *hud;


@implementation EditVideoViewController
@synthesize dict_VideoAlldetails;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:(204/255.0) green:(229/255.0) blue:(255/255.0) alpha:1];
    
    [self performSelectorInBackground:@selector(CallCategoryWebservice) withObject:nil];
    Bool_VideoCamera=NO;

    self.navigationItem.title=@"Edit Media";
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:(255/255.0) green:(172/255.0) blue:(0/255.0) alpha:1] forKey:NSForegroundColorAttributeName];

    _txt_title.text=[dict_VideoAlldetails objectForKey:@"title"];
    _txt_category.text=[dict_VideoAlldetails objectForKey:@"category"];
    _txt_overleyposition.text=[dict_VideoAlldetails objectForKey:@"overlay"];
    _txt_title.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txt_title.layer.borderWidth=2.5;
    _txt_title.layer.cornerRadius = 10;
    
    _txt_category.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txt_category.layer.borderWidth=2.5;
    _txt_category.layer.cornerRadius = 10;

    _txt_overleyposition.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txt_overleyposition.layer.borderWidth=2.5;
    _txt_overleyposition.layer.cornerRadius = 10;

    if ([[dict_VideoAlldetails objectForKey:@"type"] isEqualToString:@"image"])
    {
        
        [_postImageView setImageWithURL:[NSURL URLWithString:[dict_VideoAlldetails objectForKey:@"path"]]
                          placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        uploadedImae=_postImageView.image;
        
        NSLog(@"%f, %f", uploadedImae.size.width, uploadedImae.size.height);
    }
    else
    {
        
        
        _videoUrl = [NSURL URLWithString:[dict_VideoAlldetails objectForKey:@"path"]];
//        [self loadVideo:_videoUrl];

        
    }

    
    
    
    // Add PiCker and Toolbar For Category
    
    myPickerView_category = [[UIPickerView alloc] init];
    myPickerView_category.showsSelectionIndicator = YES;
    myPickerView_category.delegate = self;
    myPickerView_category.backgroundColor=[UIColor whiteColor];
    myPickerView_category.tag=103;
    myPickerView_category.dataSource = self;
    
    
    toolbar_category =[[UIToolbar alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,44)];
    toolbar_category.backgroundColor=[UIColor whiteColor];

    UIBarButtonItem *cancelButton3 = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(cancelButtonPressed_category:)];
    
    UIBarButtonItem *flexibleSpace3 =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:self
                                                                                  action:nil];
    
    UIBarButtonItem *doneButton3 =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(doneButtonPressed_cayegory:)];
    [toolbar_category setItems:@[cancelButton3,flexibleSpace3, doneButton3]];
    
    
    
    _txt_category.inputView = myPickerView_category;
    _txt_category.inputAccessoryView = toolbar_category;
    
    
    
    
    // Add PiCker and Toolbar For Category
    
    myPickerView_overley = [[UIPickerView alloc] init];
    myPickerView_overley.showsSelectionIndicator = YES;
    myPickerView_overley.delegate = self;
    myPickerView_overley.tag=104;
    myPickerView_overley.backgroundColor=[UIColor whiteColor];
    myPickerView_overley.dataSource = self;
    
    
    toolbar_overley =[[UIToolbar alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,44)];
    toolbar_overley.backgroundColor=[UIColor whiteColor];

    UIBarButtonItem *cancelButton_overley = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(cancelButtonPressed_Overley:)];
    
    UIBarButtonItem *flexible_overley =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                  target:self
                                                                                  action:nil];
    
    UIBarButtonItem *doneButton_overley =[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(doneButtonPressed_Overley:)];
    [toolbar_overley setItems:@[cancelButton_overley,flexible_overley, doneButton_overley]];
    
    
    
    _txt_overleyposition.inputView = myPickerView_overley;
    _txt_overleyposition.inputAccessoryView = toolbar_overley;



    

    // Do any additional setup after loading the view.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.txt_title == textField )
    {
        textField.text=[textField.text capitalizedString];
    }
    
    return YES;
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
//    nIndex = row;
    if (pickerView.tag==103)
    {
        _txt_category.text=[Arr_CategoryAlldetails objectAtIndex:row];
    }
    else
    {
        _txt_overleyposition.text=[Arr_OverlayAlldetails objectAtIndex:row];
    }
    
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
     if (pickerView.tag==103)
    {
        return [Arr_CategoryAlldetails count];
    }
    else
    {
        return [Arr_OverlayAlldetails count];
    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    if (pickerView.tag==103)
    {
        
        return [Arr_CategoryAlldetails objectAtIndex:row];
    }
    else
    {
        
        return [Arr_OverlayAlldetails objectAtIndex:row];
    }
}
#pragma mark 
#pragma mark TextFeild Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField             // called when 'return' key pressed. return NO to ignore.
{
    [textField resignFirstResponder];
    return YES;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)vedioClick:(id)sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:Nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Take Video",@"Choose Existing Photo",@"Choose Existing  Video", nil];
    actionSheet.tag=1001;
    actionSheet.delegate=self;
    [actionSheet showInView:self.view];
    
}
- (IBAction)btn_postClicked:(id)sender {
    
    
    if (![self isValidTextField])
    {
        return;
    }
    
    [self.indicator startAnimating];
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud show:YES];

    [self performSelector:@selector(insertImageORVideo) withObject:self afterDelay:0.1];
    
    
}

-(IBAction)cancelButtonPressed_category:(id)sender
{
    [_txt_category resignFirstResponder];
}

-(IBAction)doneButtonPressed_cayegory:(id)sender
{
    if ([_txt_category.text isEqualToString:@""])
    {
        _txt_category.text=[Arr_CategoryAlldetails objectAtIndex:0];
    }

    [_txt_category resignFirstResponder];
    
}



-(IBAction)doneButtonPressed_Overley:(id)sender
{
    
    if ([_txt_overleyposition.text isEqualToString:@""])
    {
        _txt_overleyposition.text=[Arr_OverlayAlldetails objectAtIndex:0];
    }

    [_txt_overleyposition resignFirstResponder];

}

-(IBAction)cancelButtonPressed_Overley:(id)sender
{
    [_txt_overleyposition resignFirstResponder];

}


#pragma mark -
#pragma mark imagePickerController delegate methods

- (void)imagePickerControllerDidStartVideoCapturing:(UIImagePickerController *)picker
{
    NSLog(@"imagePickerControllerDidStartVideoCapturing");
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"%@",mediaType);

    if ([mediaType isEqualToString:@"public.image"])
    {
        
        NSData *data=UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0);
        
        uploadedImae = [UIImage imageWithData:data];
        
        uploadedImae = [self fixrotation:uploadedImae];


        
        //        uploadedImae =
        //        [UIImage imageWithCGImage:[uploadedImae CGImage]
        //                            scale:1.0
        //                      orientation: UIImageOrientationUp];
        //  uploadedImae = [self scaleAndRotateImage:uploadedImae];
        [self LoadImage:uploadedImae];
        
        _videoUrl=nil;


        [picker dismissViewControllerAnimated:YES completion:^{
            
            
        }];
    }
    else
    {
        NSLog(@"Video Send");
        
        isvideoupdate=YES;
        NSURL* videoUrl = info[UIImagePickerControllerMediaURL];
        _videoUrl = [[NSURL alloc] initWithString:[videoUrl absoluteString]];
        [self loadVideo:_videoUrl];
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}


- (UIImage *)fixrotation:(UIImage *)image{
    
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        Bool_VideoCamera=NO;
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.videoQuality=UIImagePickerControllerQualityTypeMedium;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:^{}];
    }
    else if (buttonIndex==1)
    {
        Bool_VideoCamera=YES;
        
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoQuality=UIImagePickerControllerQualityTypeMedium;
        imagePicker.mediaTypes = @[(NSString*)kUTTypeMovie];
        
        // For capturing both images and video from camera use this code.
        //  imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeMovie, (NSString*)kUTTypeImage,nil];
        
  //      imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
  //      imagePicker.videoMaximumDuration = 120;
        imagePicker.delegate = self;
        
        [self presentViewController:imagePicker animated:YES completion:nil];

    }
    else if (buttonIndex==2)
    {
        Bool_VideoCamera=NO;
        //Choose Existing Photo
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.videoQuality=UIImagePickerControllerQualityTypeMedium;
        picker.modalPresentationStyle = UIModalPresentationCurrentContext;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:^{}];
        
    }
    else if (buttonIndex==3)
    {
        Bool_VideoCamera=NO;        
        //Choose Existing Photo
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.videoQuality=UIImagePickerControllerQualityTypeMedium;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = @[(NSString*)kUTTypeMovie];
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}




#pragma mark -
#pragma mark User Functions

// implement mpmovie player to load video and get thumbnail image
- (void)loadVideo:(NSURL*)url
{
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:url];
    UIImage  *thumbnailImage = [player thumbnailImageAtTime:1.0 timeOption:
                                MPMovieTimeOptionNearestKeyFrame];
    player = nil;
    _postImageView.image = thumbnailImage; // set thumbnail image to post imageview

    
    
}

-(void)LoadImage:(UIImage *)imgename
{
    _postImageView.image=imgename;
}

-(BOOL)isValidTextField
{
    
    if (_txt_title.text.length==0)
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:@"Title should not be blank"];
        return NO;
    }
    else if (_txt_category.text.length==0)
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:@"You have not selected any category"];
        return NO;
    }
    
    else if (_txt_overleyposition.text.length==0)
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:@"You have not selected any overlay position"];
        return NO;
    }
    else  if(_postImageView.image == nil)
    {
        [ApplicationDelegate ShowAlertOnTitle:nil Message:@"You have not selected any video or image"];
        return NO;
    }
    
    return YES;
    
}

#pragma mark call ImageUpload Webservice

-(void)CallCategoryWebservice
{
    
    NSString *appurl =[NSString stringWithFormat:@"%@/listcategory",ApplicationDelegate.Mainurl];
    appurl = [appurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request1=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appurl]];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request1 returningResponse: nil error: nil ];
    NSString  *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    NSMutableDictionary *dict_Category=[returnString JSONValue];
    Dict_categoryAlldetails=[[dict_Category objectForKey:@"response"] mutableCopy];
    [self performSelectorOnMainThread:@selector(CompleteProcess_categort:) withObject:dict_Category waitUntilDone:YES];

}
-(void)CompleteProcess_categort:(NSMutableDictionary *)dict
{
    NSLog(@"%@",dict);
    NSLog(@"%@",[[dict valueForKey:@"response"] allValues]);
    Arr_CategoryAlldetails=(NSMutableArray *)[[dict valueForKey:@"response"] allValues];
    
    
    
    [self performSelectorInBackground:@selector(CallOverlayAllWebservice) withObject:nil];


}
-(void)CallOverlayAllWebservice
{
    NSString *appurl =[NSString stringWithFormat:@"%@/listoverlay",ApplicationDelegate.Mainurl];
    appurl = [appurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request1=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appurl]];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request1 returningResponse: nil error: nil ];
    NSString  *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    NSMutableDictionary *dict_overlay=[returnString JSONValue];
    Dict_OverleyAlldetails=[[dict_overlay objectForKey:@"response"]mutableCopy];

    [self performSelectorOnMainThread:@selector(CompleteProcess_Overlay:) withObject:dict_overlay waitUntilDone:YES];

}
-(void)CompleteProcess_Overlay:(NSMutableDictionary *)dict
{
    NSLog(@"%@",[[dict valueForKey:@"response"] allValues]);
    Arr_OverlayAlldetails=(NSMutableArray *)[[dict valueForKey:@"response"] allValues];
    NSLog(@"%@",_txt_category.text);
    NSLog(@"%@",_txt_overleyposition.text);
    
    NSLog(@"%@",Arr_OverlayAlldetails);
    NSLog(@"%@",Arr_CategoryAlldetails);
    
    
    NSInteger index_cat= [Arr_CategoryAlldetails indexOfObject:_txt_category.text];
    
    NSInteger inx_overllay= [Arr_OverlayAlldetails indexOfObject:_txt_overleyposition.text];


    [myPickerView_category selectRow:index_cat inComponent:0 animated:NO];
    [myPickerView_overley selectRow:inx_overllay inComponent:0 animated:NO];
}

-(void)insertImageORVideo
{
    

    
    NSString *str_selectedCategory = _txt_category.text;
    NSArray *temp_category = [Dict_categoryAlldetails allKeysForObject:str_selectedCategory];
    NSString *Str_category_id = [temp_category objectAtIndex:0];

    
    
    NSString *str_selectedOverley = _txt_overleyposition.text;
    NSArray *temp_overley = [Dict_OverleyAlldetails allKeysForObject:str_selectedOverley];
    NSString *Str_Overley_id = [temp_overley objectAtIndex:0];
    NSData *image_videoData;
    NSString *encodedString;

    if (_videoUrl==Nil)
    {
        NSLog(@"image upload");
        Media_Type=@"Image";
        image_videoData = UIImageJPEGRepresentation(uploadedImae, 0.8);
        encodedString = [image_videoData base64Encoding];
    }
    else
    {
        NSLog(@"video upload");
        Media_Type=@"Video";
        
        if (isvideoupdate==YES)
        {
            image_videoData = [NSData dataWithContentsOfFile:[_videoUrl path]];

        }
        else
        {
            image_videoData = [NSData dataWithContentsOfURL:_videoUrl];

        }
        encodedString = [image_videoData base64Encoding];

    }
    
    NSString *urlpath = [NSString stringWithFormat:@"%@webserviceupdatemedia",ApplicationDelegate.Mainurl];
    
    
    
/*    NSURL *url = [NSURL URLWithString:[urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    request = [ASIFormDataRequest requestWithURL:url];
    
    
    [request setPostValue:ApplicationDelegate.Userid forKey:@"user_id"];
    [request setPostValue:_txt_title.text forKey:@"title"];
    [request setPostValue:Media_Type forKey:@"type"];
    [request setPostValue:[dict_VideoAlldetails objectForKey:@"id"] forKey:@"id"];
    
    if (Bool_VideoCamera)
    {
        [request setPostValue:@"1" forKey:@"IsRotate"];
    }
    else
    {
        [request setPostValue:@"0" forKey:@"IsRotate"];
    }

    [request setPostValue:Str_category_id forKey:@"category_id"];
    [request setPostValue:Str_Overley_id forKey:@"overlay_position"];
    [request setPostValue:@"Upload" forKey:@"submit"];
    [request setPostValue:encodedString forKey:@"data"];
    
    //    [request setFile:urlString forKey:@"videoFile"];
    [request setRequestMethod:@"POST"];
    [request setDelegate:self];
    [request setDidStartSelector:@selector(requestStarted:)];
    [request setDidFinishSelector:@selector(requestFinished:)];
    [request setDidFailSelector:@selector(requestFailed:)];
    [request setUploadProgressDelegate:self];
    [request setTimeOutSeconds:60000];
    [request startAsynchronous];
    NSLog(@"responseStatusCode %i",[request responseStatusCode]);
    NSLog(@"responseStatusCode %@",[request responseString]);*/

    
    NSMutableData *body = [NSMutableData data];
    
    NSLog(@"%@",ApplicationDelegate.Userid);
    request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@webserviceupload",ApplicationDelegate.Mainurl]]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:600000];

    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    // MediId parameter
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent, @"id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[dict_VideoAlldetails objectForKey:@"id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];

    
    // USerid parameter
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent, @"user_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[ApplicationDelegate.Userid dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // title parameter
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent, @"title"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[_txt_title.text dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // type parameter
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent, @"type"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[Media_Type dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // category_id parameter
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent ,@"category_id"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[Str_category_id dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // overlay_position parameter
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent, @"overlay_position"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[Str_Overley_id dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // submit parameter
    [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kContent, @"submit"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Upload" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    
    if (Bool_VideoCamera)
    {
        // overlay_position parameter
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent, @"IsRotate"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"1" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        // overlay_position parameter
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kContent, @"IsRotate"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"0" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
        
    }
    
    
    if (_videoUrl==Nil)
    {
        // image File
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpeg\r\n", @"file_name"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:image_videoData];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];

    }
    else
    {
        // video file
        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Disposition: form-data; name=\"file_name\"; filename=\"video.mp4\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[NSData dataWithData:image_videoData]];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];

    }
    
    
    

    
    // close form
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSMutableDictionary *dict_ResponceBg = [returnString JSONValue];
    NSLog(@"responce %@",dict_ResponceBg);
    
    if ([[dict_ResponceBg objectForKey:@"response"] objectForKey:@"success"])
    {
        _videoUrl=nil;
        [ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict_ResponceBg objectForKey:@"response"] objectForKey:@"success"] objectAtIndex:0]];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            //Do not forget to import AnOldViewController.h
            if ([controller isKindOfClass:[VideoListViewController class]]) {
                
                [self.navigationController popToViewController:controller
                                                      animated:YES];
                break;
            }
        }

    }

    [self.indicator stopAnimating];
    [hud hide:YES];

    
    
    
    
}

- (void)requestStarted:(ASIHTTPRequest *)theRequest
{
    NSLog(@"response started new::%@",[theRequest responseString]);
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest {
    NSLog(@"response finished new ::%@",[theRequest responseString]);
    [hud hide:YES];
    NSMutableDictionary *dict_ResponceBg = [[theRequest responseString] JSONValue];
    
        if ([[dict_ResponceBg objectForKey:@"response"] objectForKey:@"success"])
        {
            _videoUrl=nil;
            [ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict_ResponceBg objectForKey:@"response"] objectForKey:@"success"] objectAtIndex:0]];
            for (UIViewController *controller in self.navigationController.viewControllers) {
                //Do not forget to import AnOldViewController.h
                if ([controller isKindOfClass:[VideoListViewController class]]) {
    
                    [self.navigationController popToViewController:controller
                                                          animated:YES];
                    break;
                }
            }
    
        }
    
        [self.indicator stopAnimating];
        [hud hide:YES];
}

- (void)requestFailed:(ASIHTTPRequest *)theRequest
{
    NSLog(@"response Failed new ::%@, Error:%@",[theRequest responseString],[theRequest error]);
    [hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Video Upload to server failed, please try again"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
}




@end
