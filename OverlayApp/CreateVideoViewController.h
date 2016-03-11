//
//  HomeViewController.h
//  OverlayApp
//
//  Created by The One Tech 29 on 4/23/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "ASIFormDataRequest.h"

@interface CreateVideoViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    
    UIImage *uploadedImae;
    
    // This is For Video and Image
    NSString *Media_Type;
    NSURL* _videoUrl;
    NSMutableArray *Arr_CategoryAlldetails;
    NSMutableArray *Arr_OverlayAlldetails;
    NSMutableDictionary *Dict_categoryAlldetails;
    NSMutableDictionary *Dict_OverleyAlldetails;
    
    
    UIPickerView *myPickerView_category;
    UIPickerView *myPickerView_overley;

    
    UIToolbar *toolbar_category;
    UIToolbar *toolbar_overley;
    
    //ASIFormDataRequest *request;
    NSMutableURLRequest *request;
    

    BOOL Bool_VideoCamera;
}

- (IBAction)vedioClick:(id)sender;




@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) IBOutlet UITextField *txt_title;
@property (strong, nonatomic) IBOutlet UITextField *txt_category;
@property (strong, nonatomic) IBOutlet UITextField *txt_overleyposition;
@property (strong, nonatomic) IBOutlet UIImageView *postImageView;
- (IBAction)btn_postClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
