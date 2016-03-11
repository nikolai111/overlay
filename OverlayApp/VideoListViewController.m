//
//  VideoListViewController.m
//  OverlayApp
//
//  Created by The One Tech 29 on 4/28/15.
//  Copyright (c) 2015 The One Tech 29. All rights reserved.
//

#import "VideoListViewController.h"
#import "JSON.h"
#import "AppDelegate.h"
#import "VideoListTableViewCell.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "VideoViewViewController.h"
#import "MBProgressHUD.h"


@interface VideoListViewController ()

@end
MBProgressHUD *hud;

@implementation VideoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tbl_videolist.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    self.view.backgroundColor=[UIColor colorWithRed:(204/255.0) green:(229/255.0) blue:(255/255.0) alpha:1];

    self.navigationItem.hidesBackButton=YES;

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconTitleview"]];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor colorWithRed:(255/255.0) green:(172/255.0) blue:(0/255.0) alpha:1] forKey:NSForegroundColorAttributeName];

    
    // Add Setting Button Programmetically
    UIImage* image_setting = [UIImage imageNamed:@"setting-icon.png"];
    CGRect backframe = CGRectMake(150, 0, 32,32);
    UIButton *settingbtn = [[UIButton alloc] initWithFrame:backframe];
    [settingbtn setBackgroundImage:image_setting forState:UIControlStateNormal];
    [settingbtn addTarget:self action:@selector(btn_Setting:)
         forControlEvents:UIControlEventTouchUpInside];
    [settingbtn setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *settingbarbutton =[[UIBarButtonItem alloc] initWithCustomView:settingbtn];
    self.navigationItem.leftBarButtonItem=settingbarbutton;
    
    // Add Setting Button Programmetically
    UIImage* image_create = [UIImage imageNamed:@"Edit.png"];
    CGRect frame = CGRectMake(150, 0, 45,45);
    UIButton *createbtn = [[UIButton alloc] initWithFrame:frame];
    [createbtn setBackgroundImage:image_create forState:UIControlStateNormal];
    [createbtn addTarget:self action:@selector(btn_CreateClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [createbtn setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *createbarbutton =[[UIBarButtonItem alloc] initWithCustomView:createbtn];
    self.navigationItem.rightBarButtonItem=createbarbutton;
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    search_bar.text=nil;
    [self.indicator startAnimating];
    [self performSelectorInBackground:@selector(CallVideoListWebservice) withObject:nil];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btn_CreateClicked:(id)sender
{
    [self performSegueWithIdentifier:@"Createnew" sender:nil];

}

-(IBAction)btn_Setting:(id)sender
{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:Nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit Profile",@"Change Password",@"Logout", nil];
    actionSheet.delegate=self;
    [actionSheet showInView:self.view];

    
}

#pragma mark
#pragma mark UIActionsheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (buttonIndex==0)
    {
        [self performSegueWithIdentifier:@"editprofile" sender:nil];
    }

   else if (buttonIndex==1)
    {
        [self performSegueWithIdentifier:@"changepwd" sender:nil];
    }
    else if (buttonIndex==2)
    {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:@"0" forKey:@"remember"];
        [defaults synchronize];
        [self.navigationController popToRootViewControllerAnimated:YES];

    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    if (alertView.tag==1001)
    {
        ApplicationDelegate.isuploadanother=0;
        if (buttonIndex==0)
        {
            //[self performSegueWithIdentifier:@"Createnew" sender:nil];
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString: ApplicationDelegate.str_redirect_path]];


            
        }
        
    }
    
}

#pragma mark - UITableViewDataSource Methods


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return Arr_VideoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VideoList";
    VideoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[VideoListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor colorWithRed:(204/255.0) green:(229/255.0) blue:(255/255.0) alpha:1];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];/// change size as you need.
    
    separatorLineView.backgroundColor = [UIColor whiteColor];// you can also put image here
    [cell.contentView addSubview:separatorLineView];

    cell.backgroundColor=[UIColor whiteColor];
    if ([[[Arr_VideoList objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"image"])
    {
        [cell.img_thumb setImageWithURL:[NSURL URLWithString:[[Arr_VideoList objectAtIndex:indexPath.row] objectForKey:@"path"]]
                          placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        cell.img_videoicon.hidden=YES;
    }
    else
    {
        [cell.img_thumb setImageWithURL:[NSURL URLWithString:[[Arr_VideoList objectAtIndex:indexPath.row] objectForKey:@"share_instagram"]]
                       placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //cell.img_thumb.image=[UIImage imageNamed:@"video-icon.png"];
        cell.img_videoicon.hidden=NO;
    }

    cell.lbl_title.text=[[Arr_VideoList objectAtIndex:indexPath.row] objectForKey:@"title"];
    cell.lbl_category.text=[[Arr_VideoList objectAtIndex:indexPath.row] objectForKey:@"category"];


    
    return cell;
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"VideoView" sender:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];

}

#pragma mark call VideoList Webservice


-(UIImage *)generateThumbImage : (NSString *)filepath
{
    
    
    
    NSURL *url = [NSURL fileURLWithPath:filepath];
    
    
    AVAsset *asset = [AVAsset assetWithURL:url];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
    CMTime time = [asset duration];
    time.value = 0;
    CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
    UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);  // CGImageRef won't be released by ARC
    
    return thumbnail;
    
}

-(void)CallVideoListWebservice
{
    [search_bar resignFirstResponder];
    
    
    NSString *appurl =[NSString stringWithFormat:@"%@/listmedia/%@",ApplicationDelegate.Mainurl,ApplicationDelegate.Userid];
    
    appurl = [appurl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:appurl]];
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error: nil ];
    NSString  *returnString = [[NSString alloc] initWithData:returnData encoding: NSUTF8StringEncoding];
    NSMutableDictionary *dict_Category=[returnString JSONValue];
    [self.indicator stopAnimating];

    [self performSelectorOnMainThread:@selector(CompleteProcess:) withObject:dict_Category waitUntilDone:YES];
}

-(void)CompleteProcess:(NSMutableDictionary *)dict
{
    if (![[dict valueForKey:@"response"] isKindOfClass:[NSDictionary class]])
    {
        Arr_VideoList=[dict objectForKey:@"response"];
        [_tbl_videolist reloadData];
    }
    else
    {
        [Arr_VideoList removeAllObjects];
        [_tbl_videolist reloadData];
        [ApplicationDelegate ShowAlertOnTitle:nil Message:[[[dict objectForKey:@"response"] objectForKey:@"error"] objectAtIndex:0]];
    }
    
    if (ApplicationDelegate.isuploadanother)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:nil message:@"Do you want to change the Default Terms?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No", nil];
        alert.tag=1001;
        [alert show];
    }
}

#pragma mark
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"VideoView"])
    {
        VideoViewViewController *obj=(VideoViewViewController *)[segue destinationViewController];
        obj.dict_VideoAlldetails=[Arr_VideoList objectAtIndex:[sender integerValue]];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    if (searchText.length >0) {
        
        NSLog(@"hello");
        NSPredicate *predicate = [NSPredicate
                                  predicateWithFormat:@"title CONTAINS[cd] %@ OR title LIKE[cd] %@",
                                  searchText,searchText];//
        
        NSMutableArray *filtered_ary=[[NSMutableArray alloc]init];
        
        filtered_ary = [(NSMutableArray *)[Arr_VideoList filteredArrayUsingPredicate:predicate]mutableCopy];
        [Arr_VideoList removeAllObjects];
        [Arr_VideoList addObjectsFromArray:filtered_ary];
        //[self webservice_public_grp];
        //mary = [[NSMutableArray alloc]initWithArray:filteredArray];
        [self.tbl_videolist reloadData];
    }else{
        [searchBar performSelector:@selector(resignFirstResponder)
                        withObject:nil
                        afterDelay:0];

        [self CallVideoListWebservice];
        
        
    }
    
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;
{
    [search_bar resignFirstResponder];
}

//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;   // called when text changes (including clear)
//{
//   // [Arr_VideoList removeAllObjects];
//    
//    if([searchText length] > 0)
//    {
//       
//        [self searchtableview];
//    }
//    else
//    {
//       
//    }
//    
//    [self.tbl_videolist reloadData];
//}
//
//
//-(void)searchtableview
//{
//    NSString *searchText = search_bar.text;
//    NSLog(@"Alert text %@",searchText);
//    
//    for(int l = 0; l < [Arr_VideoList count]; l++)
//    {
//        NSString *tempstr = [[Arr_VideoList objectAtIndex:l] valueForKey:@"title"];
//        NSRange rngstr = [tempstr rangeOfString:searchText options:(NSAnchoredSearch | NSCaseInsensitiveSearch)];
//        NSLog(@"%d",rngstr);
//        
//        if(rngstr.length > 0)
//        {
//            NSMutableArray *mry=[[NSMutableArray alloc]init];
//            [mry addObject:[Arr_VideoList objectAtIndex:l]];
//            [Arr_VideoList removeAllObjects];
//            [Arr_VideoList addObjectsFromArray:mry];
//            
//        }
//    }
//    
//    [self.tbl_videolist reloadData];
//}

@end
