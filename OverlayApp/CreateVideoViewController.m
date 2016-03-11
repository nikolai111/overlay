//
//  HomeViewController.m
//  OverlayApp
//
//  Created by The One Tech 29 on 4/23/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import "CreateVideoViewController.h"
#import "JSON.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"

#define kStartTag   @"--%@\r\n"
#define kEndTag     @"\r\n"
#define kContent    @"Content-Disposition: form-data; name=\"%@\"\r\n\r\n"
#define kBoundary   @"---------------------------14737809831466499882746641449"
@interface CreateVideoViewController ()

@end
MBProgressHUD *hud;


@implementation CreateVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor colorWithRed:(204/255.0) green:(229/255.0) blue:(255/255.0) alpha:1];
    
    [self performSelectorInBackground:@selector(CallCategoryWebservice) withObject:nil];

    Bool_VideoCamera=NO;
    
    self.navigationItem.title=@"Upload Media";
    
    _txt_title.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txt_title.layer.borderWidth=2.5;
    _txt_title.layer.cornerRadius = 10;

    _txt_category.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txt_category.layer.borderWidth=2.5;
    _txt_category.layer.cornerRadius = 10;

    _txt_overleyposition.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    _txt_overleyposition.layer.borderWidth=2.5;
    _txt_overleyposition.layer.cornerRadius = 10;

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
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(refreshClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    
}

- (IBAction)refreshClicked:(id)sender {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://snapsyn.com/cms/index/Tutorials"]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.txt_title == textField )
    {
        textField.text=[textField.text capitalizedString];
    }
    
    return YES;
}


#pragma mark
#pragma mark Pickerview Delegate and Datasources
//picker
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
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

- (UIImage *)scaleAndRotateImage:(UIImage *)image
{
    int kMaxResolution = 320; // Or whatever
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    if (width > kMaxResolution || height > kMaxResolution) {
        CGFloat ratio = width/height;
        if (ratio > 1) {
            bounds.size.width = kMaxResolution;
            bounds.size.height = bounds.size.width / ratio;
        }
        else {
            bounds.size.height = kMaxResolution;
            bounds.size.width = bounds.size.height * ratio;
        }
    }
    
    CGFloat scaleRatio = bounds.size.width / width;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = image.imageOrientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    }
    else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    NSLog(@"%@",mediaType);
    
    
    if ([mediaType isEqualToString:@"public.image"])
    {
        
        NSData *data=UIImageJPEGRepresentation([info objectForKey:UIImagePickerControllerOriginalImage], 0);

        uploadedImae = [UIImage imageWithData:data];
        
        
        uploadedImae = [self scaleAndRotateImage:uploadedImae];

        NSLog(@"%f, %f", uploadedImae.size.width, uploadedImae.size.height);
        
        

//        uploadedImae =
//        [UIImage imageWithCGImage:[uploadedImae CGImage]
//                            scale:1.0
//                      orientation: UIImageOrientationUp];
      //  uploadedImae = [self scaleAndRotateImage:uploadedImae];
        [self LoadImage:uploadedImae];
 
        [picker dismissViewControllerAnimated:YES completion:^{
            
            
        }];
    }
    else
    {
        NSLog(@"Video Send");
        
        
        
        NSURL* videoUrl = info[UIImagePickerControllerMediaURL];
        _videoUrl = [[NSURL alloc] initWithString:[videoUrl absoluteString]];
       // [self videoFixOrientation:videoUrl];

        [self loadVideo:[[NSURL alloc] initWithString:[videoUrl absoluteString]]];
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
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.videoQuality=UIImagePickerControllerQualityTypeMedium;
        [self presentViewController:picker animated:YES completion:^{}];
    }
    else if (buttonIndex==1)
    {
        UIImagePickerController* imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.videoQuality=UIImagePickerControllerQualityTypeMedium;
        imagePicker.mediaTypes = @[(NSString*)kUTTypeMovie];
        
         Bool_VideoCamera=YES;
        // For capturing both images and video from camera use this code.
        //  imagePicker.mediaTypes = [NSArray arrayWithObjects:(NSString*)kUTTypeMovie, (NSString*)kUTTypeImage,nil];
        
 //       imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
 //       imagePicker.videoMaximumDuration = 120;
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



- (void)videoFixOrientation:(NSURL *)Videourl{
    AVAsset *firstAsset = [AVAsset assetWithURL:Videourl];
    if(firstAsset !=nil && [[firstAsset tracksWithMediaType:AVMediaTypeVideo] count]>0){
        //Create AVMutableComposition Object.This object will hold our multiple AVMutableCompositionTrack.
        AVMutableComposition* mixComposition = [[AVMutableComposition alloc] init];
        
        //VIDEO TRACK
        AVMutableCompositionTrack *firstTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [firstTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        AVMutableVideoCompositionInstruction * MainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
        MainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, firstAsset.duration);
        
        if ([[firstAsset tracksWithMediaType:AVMediaTypeAudio] count]>0) {
            //AUDIO TRACK
            AVMutableCompositionTrack *firstAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
            [firstAudioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, firstAsset.duration) ofTrack:[[firstAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
        }else{
            NSLog(@"warning: video has no audio");
        }
        
        //FIXING ORIENTATION//
        AVMutableVideoCompositionLayerInstruction *FirstlayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:firstTrack];
        
        AVAssetTrack *FirstAssetTrack = [[firstAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
        
        UIImageOrientation FirstAssetOrientation_  = UIImageOrientationUp;
        
        BOOL  isFirstAssetPortrait_  = NO;
        
        CGAffineTransform firstTransform = FirstAssetTrack.preferredTransform;
        
        if(firstTransform.a == 0 && firstTransform.b == 1.0 && firstTransform.c == -1.0 && firstTransform.d == 0)
        {
            FirstAssetOrientation_= UIImageOrientationRight; isFirstAssetPortrait_ = YES;
        }
        if(firstTransform.a == 0 && firstTransform.b == -1.0 && firstTransform.c == 1.0 && firstTransform.d == 0)
        {
            FirstAssetOrientation_ =  UIImageOrientationLeft; isFirstAssetPortrait_ = YES;
        }
        if(firstTransform.a == 1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == 1.0)
        {
            FirstAssetOrientation_ =  UIImageOrientationUp;
        }
        if(firstTransform.a == -1.0 && firstTransform.b == 0 && firstTransform.c == 0 && firstTransform.d == -1.0)
        {
            FirstAssetOrientation_ = UIImageOrientationDown;
        }
        
        CGFloat FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.width;
        
        if(isFirstAssetPortrait_)
        {
            FirstAssetScaleToFitRatio = 320.0/FirstAssetTrack.naturalSize.height;
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor) atTime:kCMTimeZero];
        }
        else
        {
            CGAffineTransform FirstAssetScaleFactor = CGAffineTransformMakeScale(FirstAssetScaleToFitRatio,FirstAssetScaleToFitRatio);
            [FirstlayerInstruction setTransform:CGAffineTransformConcat(CGAffineTransformConcat(FirstAssetTrack.preferredTransform, FirstAssetScaleFactor),CGAffineTransformMakeTranslation(0, 160)) atTime:kCMTimeZero];
        }
        [FirstlayerInstruction setOpacity:0.0 atTime:firstAsset.duration];
        
        MainInstruction.layerInstructions = [NSArray arrayWithObjects:FirstlayerInstruction,nil];;
        
        AVMutableVideoComposition *MainCompositionInst = [AVMutableVideoComposition videoComposition];
        MainCompositionInst.instructions = [NSArray arrayWithObject:MainInstruction];
        MainCompositionInst.frameDuration = CMTimeMake(1, 30);
        MainCompositionInst.renderSize = CGSizeMake(320.0, 480.0);
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"mergeVideo-%d.mov",arc4random() % 1000]];
        
        NSURL *url = [NSURL fileURLWithPath:myPathDocs];
        
        AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
        
        exporter.outputURL=url;
        exporter.outputFileType = AVFileTypeQuickTimeMovie;
        exporter.videoComposition = MainCompositionInst;
        exporter.shouldOptimizeForNetworkUse = YES;
        [exporter exportAsynchronouslyWithCompletionHandler:^
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self exportDidFinish:exporter];
             });
         }];
    }else{
        NSLog(@"Error, video track not found");
    }
}

- (void)exportDidFinish:(AVAssetExportSession*)session
{
    if(session.status == AVAssetExportSessionStatusCompleted){
        NSLog(@"%@",session.outputURL);
        _videoUrl=session.outputURL;
        
        {
            NSURL *outputURL = session.outputURL;
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputURL]) {
                [library writeVideoAtPathToSavedPhotosAlbum:outputURL completionBlock:^(NSURL *assetURL, NSError *error){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error) {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                                           delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                        } else {
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                        }
                    });
                }];
            } 
        }
#warning DO WHAT EVER YOU NEED AFTER FIXING ORIENTATION
    }else{
        NSLog(@"error fixing orientation");
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
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appurl]];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];
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
    
    
    Arr_CategoryAlldetails = [Arr_CategoryAlldetails sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
    }];
    
    
    [self performSelectorInBackground:@selector(CallOverlayAllWebservice) withObject:nil];
}

-(void)CallOverlayAllWebservice
{
    NSString *appurl =[NSString stringWithFormat:@"%@/listoverlay",ApplicationDelegate.Mainurl];
    appurl = [appurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appurl]];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];
    NSString  *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    NSMutableDictionary *dict_overlay=[returnString JSONValue];
    Dict_OverleyAlldetails=[[dict_overlay objectForKey:@"response"]mutableCopy];

    [self performSelectorOnMainThread:@selector(CompleteProcess_Overlay:) withObject:dict_overlay waitUntilDone:YES];

}
-(void)CompleteProcess_Overlay:(NSMutableDictionary *)dict
{
    NSLog(@"%@",[[dict valueForKey:@"response"] allValues]);
    Arr_OverlayAlldetails=(NSMutableArray *)[[dict valueForKey:@"response"] allValues];
    _txt_category.text=[Arr_CategoryAlldetails objectAtIndex:0];
    _txt_overleyposition.text=[Arr_OverlayAlldetails objectAtIndex:0];

    
    
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
 //   NSMutableURLRequest *request12 = nil;

    NSString *encodedString;

    if (_videoUrl==Nil)
    {
        NSLog(@"image upload");
        Media_Type=@"Image";

        image_videoData = UIImageJPEGRepresentation(uploadedImae, 1.0);
 //        encodedString = [image_videoData base64Encoding];
    }
    else
    {
        NSLog(@"video upload");
        Media_Type=@"Video";
        
   //     encodedString = [[NSData dataWithContentsOfURL:_videoUrl] base64Encoding];
    }
    
    
    
 /*   NSString *urlpath = [NSString stringWithFormat:@"%@webserviceupload",ApplicationDelegate.Mainurl];
    
    
    NSURL *url = [NSURL URLWithString:[urlpath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    request = [ASIFormDataRequest requestWithURL:url];
    
    
    [request setPostValue:ApplicationDelegate.Userid forKey:@"user_id"];
    [request setPostValue:_txt_title.text forKey:@"title"];
    [request setPostValue:Media_Type forKey:@"type"];
    [request setPostValue:Str_category_id forKey:@"category_id"];
    [request setPostValue:Str_Overley_id forKey:@"overlay_position"];
    [request setPostValue:@"Upload" forKey:@"submit"];
    [request setPostValue:encodedString forKey:@"data"];
    
    if (Bool_VideoCamera)
    {
        [request setPostValue:@"1" forKey:@"IsRotate"];
    }
    else
    {
        [request setPostValue:@"0" forKey:@"IsRotate"];
    }
    
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
  
//    NSString *encodedString;
//    encodedString = [image_videoData base64Encoding];
//    encodedString = [[NSData dataWithContentsOfURL:_videoUrl] base64Encoding];
    
   
    
    
    
    if (_videoUrl==Nil)
    {
        // image File
        NSData *image_videoData = UIImageJPEGRepresentation(uploadedImae, 1.0);

        [body appendData:[[NSString stringWithFormat:kStartTag, kBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpeg\r\n", @"file_name"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:image_videoData];
        [body appendData:[[NSString stringWithFormat:kEndTag] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else
    {
        // video file
        NSData *image_videoData=[NSData dataWithContentsOfURL:_videoUrl];
        
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
        ApplicationDelegate.isuploadanother=1;
        ApplicationDelegate.str_redirect_path=[[[dict_ResponceBg objectForKey:@"response"] objectForKey:@"redirect_path"] objectAtIndex:0];

        NSLog(@"%@",[[[dict_ResponceBg objectForKey:@"response"] objectForKey:@"redirect_path"] objectAtIndex:0]);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[[[dict_ResponceBg objectForKey:@"response"] objectForKey:@"success"] objectAtIndex:0] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=1005;
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];


//        [ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict_ResponceBg objectForKey:@"response"] objectForKey:@"success"] objectAtIndex:0]];
        
        [self.navigationController popViewControllerAnimated:YES];

    }

    [self.indicator stopAnimating];
    
    [hud hide:YES];
   

}


- (void)requestStarted:(ASIHTTPRequest *)theRequest
{
    NSLog(@"response started new::%@",[theRequest responseString]);
}

- (void)requestFinished:(ASIHTTPRequest *)theRequest
{
    NSLog(@"response finished new ::%@",[theRequest responseString]);
    [hud hide:YES];
    NSMutableDictionary *dict_ResponceBg = [[theRequest responseString] JSONValue];

    if ([[dict_ResponceBg objectForKey:@"response"] objectForKey:@"success"])
    {
        _videoUrl=nil;
        ApplicationDelegate.isuploadanother=1;
        ApplicationDelegate.str_redirect_path=[[[dict_ResponceBg objectForKey:@"response"] objectForKey:@"redirect_path"] objectAtIndex:0];
        
        NSLog(@"%@",[[[dict_ResponceBg objectForKey:@"response"] objectForKey:@"redirect_path"] objectAtIndex:0]);
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:[[[dict_ResponceBg objectForKey:@"response"] objectForKey:@"success"] objectAtIndex:0] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=1005;
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        
        
        //        [ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict_ResponceBg objectForKey:@"response"] objectForKey:@"success"] objectAtIndex:0]];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    }}

- (void)requestFailed:(ASIHTTPRequest *)theRequest
{
    NSLog(@"response Failed new ::%@, Error:%@",[theRequest responseString],[theRequest error]);
    [hud hide:YES];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Video Upload to server failed, please try again"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    [alert show];
    
}
@end
