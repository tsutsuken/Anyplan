//
//  EditTaskViewController.m
//  AnyPlan
//
//  Created by Ken Tsutsumi on 13/04/25.
//  Copyright (c) 2013年 Ken Tsutsumi. All rights reserved.
//

#import "EditTaskViewController.h"

#define kMaxSizeForMemoLabel CGSizeMake(197, 2000)


@interface EditTaskViewController ()

@property (strong, nonatomic) IBOutlet UITableView *myTableView;
@property (strong, nonatomic) NSString *tempTitle;//画面遷移時にも、値を保持するため
@property (assign, nonatomic) BOOL shouldDeleteTask;

@end

@implementation EditTaskViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.myTableView reloadData];//Task編集後のデータを反映させるため
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tempTitle = self.task.title;
    
    self.tabBarController.viewDeckController.enabled = NO;

    if (self.isNewTask)
    {
        self.title = NSLocalizedString(@"EditTaskView_Title_NewTask", nil);
    }
    else
    {
        self.title = NSLocalizedString(@"EditTaskView_Title_ExistingTask", nil);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!self.tempTitle)
    {
        [self showKeyBoard];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showKeyBoard
{
    EditableCell *editableCell = (EditableCell *)[self.myTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [editableCell.textField becomeFirstResponder];
}

#pragma mark - CloseView

- (void)viewWillDisappear:(BOOL)animated
{
    if (![[self.navigationController viewControllers] containsObject:self])//前のViewに戻った時
    {
        self.tabBarController.viewDeckController.enabled = YES;
        
        if (self.shouldDeleteTask)
        {
            [self.task.managedObjectContext deleteObject:self.task];
        }
        else//BackButton Pushed
        {
            if(!self.tempTitle||[self.tempTitle isEqualToString:@""])
            {
                if (self.isNewTask)
                {
                    [self.task.managedObjectContext deleteObject:self.task];
                }
                else
                {
                    self.task.title = NSLocalizedString(@"Common_Untitled", nil);
                }
            }
            else
            {
                self.task.title = self.tempTitle;
            }
        }
        
        [self.task saveContext];
    }
    else//次のViewに行った時
    {
        //[self hideKeyBoard];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        EditableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EditableCell"];
        
        cell.textField.delegate = self;
        cell.textField.placeholder = NSLocalizedString(@"EditTaskView_Cell_Title_Placeholder", nil);
        cell.textField.text = self.tempTitle;
        
        return cell;
    }
    else if (indexPath.row == 1)
    {
        ProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProjectCell"];
        cell.titleLabel.text = NSLocalizedString(@"EditTaskView_Cell_Project", nil);
        cell.detailLabel.text = self.task.project.title;
        cell.iconView.image = self.task.project.icon;
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MemoCell"];
        cell.textLabel.text = NSLocalizedString(@"EditTaskView_Cell_Memo", nil);
        cell.detailTextLabel.text = self.task.memo;
        
        //ラベルのサイズを設定
        CGSize labelSize = [self.task.memo sizeWithFont:cell.detailTextLabel.font
                             constrainedToSize:kMaxSizeForMemoLabel
                                 lineBreakMode:cell.detailTextLabel.lineBreakMode];
        cell.detailTextLabel.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
        
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 2)
    {
        float heightForMemoCell;
        
        UITableViewCell *memoCell = [self tableView:self.myTableView cellForRowAtIndexPath:indexPath];
        float memoLabelHeight = memoCell.detailTextLabel.frame.size.height;
        heightForMemoCell = MAX(memoLabelHeight + 20, self.myTableView.rowHeight);
        
        return heightForMemoCell;
    }
    else
    {
        return self.myTableView.rowHeight;
    }
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (indexPath.row == 0)
    {
        return nil;
    }
    else
    {
        return indexPath;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
    }
    else if (indexPath.row == 1)
    {
        [self showSelectProjectView];
    }
    else
    {
        [self showEditMemoView];
    }
}

#pragma mark - Show Other Views

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    LOG(@"%@", [segue identifier]);
    
    if([[segue identifier] isEqualToString:@"showSelectProjectView"])
    {
        SelectProjectViewController *controller = (SelectProjectViewController *)segue.destinationViewController;
        controller.editedObject = self.task;
    }
    else if([[segue identifier] isEqualToString:@"showEditMemoView"])
    {
        EditMemoViewController *controller = (EditMemoViewController *)segue.destinationViewController;
        controller.task = self.task;
    }
}

#pragma mark SelectProjectView

- (void)showSelectProjectView
{
    [self performSegueWithIdentifier:@"showSelectProjectView" sender:self];
}

#pragma mark EditMemoView

- (void)showEditMemoView
{
    [self performSegueWithIdentifier:@"showEditMemoView" sender:self];
}

#pragma mark - TextField delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.tempTitle = [textField.text stringByReplacingCharactersInRange:range withString:string];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Delete Task

- (IBAction)didPushDeleteButton
{
    [self showActionSheetForDeletingTask];
}

- (void)showActionSheetForDeletingTask
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    actionSheet.delegate = self;
    
    [actionSheet addButtonWithTitle:NSLocalizedString(@"EditTaskView_ActionSheet_Button_Delete", nil)];
    [actionSheet addButtonWithTitle:NSLocalizedString(@"EditTaskView_ActionSheet_Button_Cancel", nil)];
    actionSheet.destructiveButtonIndex = 0;
    actionSheet.cancelButtonIndex = 1;
    
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{    
    switch (buttonIndex) {
        case 0:
            [self closeViewWithDeletingTask];
            break;
        case 1:
            //Do Nothing
            break;
    }
}

- (void)closeViewWithDeletingTask
{
    self.shouldDeleteTask = YES;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
