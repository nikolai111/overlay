//
//  VideoListTableViewCell.h
//  OverlayApp
//
//  Created by The One Tech 29 on 4/28/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lbl_title;
@property (strong, nonatomic) IBOutlet UILabel *lbl_category;
@property (strong, nonatomic) IBOutlet UIImageView *img_thumb;
@property (strong, nonatomic) IBOutlet UIImageView *img_videoicon;

@end
