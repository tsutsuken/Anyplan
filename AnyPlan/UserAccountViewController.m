//
//  UserAccountViewController.m
//  AnyPlan
//
//  Created by Ken Tsutsumi on 2013/06/28.
//  Copyright (c) 2013年 Ken Tsutsumi. All rights reserved.
//

#import "UserAccountViewController.h"

@interface UserAccountViewController ()

@property (strong, nonatomic) MBProgressHUD *HUD;

@end

@implementation UserAccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"UserAccountView_Title", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];//Account情報変更後のデータを反映させるため
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString(@"UserAccountView_Cell_Email", nil);
        cell.detailTextLabel.text = [[PFUser currentUser] email];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LogOutCell" forIndexPath:indexPath];
        cell.textLabel.text = NSLocalizedString(@"UserAccountView_Cell_Restore", nil);
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        [self showChangeEmailView];
    }
    else
    {
        [self restorePurchase];
    }
}

#pragma mark - Restore

- (void)restorePurchase
{
    [self showHUD];
    
    [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^()
    {
        LOG(@"Restored");
        [self hideHUDWithCompleted:YES];
    }
                                                                  onError:^(NSError* error)
    {
        LOG(@"Canceled");
        [self hideHUDWithCompleted:NO];
    }];
}

- (void)showHUD
{
	self.HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:self.HUD];
	
	self.HUD.delegate = self;
	self.HUD.labelText = NSLocalizedString(@"UserAccountView_HUD_Restore", nil);
	self.HUD.minSize = CGSizeMake(135.f, 135.f);
	
	[self.HUD show:YES];
}

- (void)hideHUDWithCompleted:(BOOL)isCompleted
{
    NSString *imageName;
    NSString *labelText;
    
    if (isCompleted)
    {
        imageName = @"check_HUD.png";
        labelText = NSLocalizedString(@"UserAccountView_HUD_Completed", nil);
    }
    else
    {
        imageName = @"cross_HUD.png";
        labelText = NSLocalizedString(@"UserAccountView_HUD_Canceled", nil);;
    }
    
    self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    self.HUD.mode = MBProgressHUDModeCustomView;
    self.HUD.labelText = labelText;
    [self.HUD hide:YES afterDelay:1];
}

#pragma mark - Show Other View
#pragma mark ChangeEmailView

- (void)showChangeEmailView
{
    [self performSegueWithIdentifier:@"showChangeEmailView" sender:self];
}

@end
