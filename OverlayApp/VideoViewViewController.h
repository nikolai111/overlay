//
//  VideoViewViewController.h
//  OverlayApp
//
//  Created by The One Tech 29 on 4/28/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <Social/Social.h>


@interface VideoViewViewController : UIViewController<UIActionSheetDelegate,UIDocumentInteractionControllerDelegate>
{
    
    NSMutableDictionary *dict_VideoAlldetails;
    
    
    MPMoviePlayerController *mpcontroller;
    UIImageView *imgInstance;
    
    NSMutableDictionary *Dict_ShareUrl;


}

@property (nonatomic, retain) UIDocumentInteractionController *dic;


@property (strong, nonatomic) IBOutlet UILabel *lbl_title;
@property (strong, nonatomic) IBOutlet UILabel *lbl_category;
@property (strong, nonatomic) IBOutlet UIImageView *imge_thumb;
@property(nonatomic,strong)NSMutableDictionary *dict_VideoAlldetails;
- (IBAction)btn_editClicked:(id)sender;
- (IBAction)btn_deleteClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
- (IBAction)btn_shareClicked:(id)sender;


@end
