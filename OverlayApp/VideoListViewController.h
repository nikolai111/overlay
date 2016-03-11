//
//  VideoListViewController.h
//  OverlayApp
//
//  Created by The One Tech 29 on 4/28/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface VideoListViewController : UIViewController<UIActionSheetDelegate,UISearchBarDelegate>
{
    NSMutableArray *Arr_VideoList;
    IBOutlet UISearchBar *search_bar;
}
@property (strong, nonatomic) IBOutlet UITableView *tbl_videolist;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@end
