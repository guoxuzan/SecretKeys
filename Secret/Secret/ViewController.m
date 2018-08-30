//
//  ViewController.m
//  Secret
//
//  Created by 郭旭赞 on 2017/1/8.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import "ViewController.h"
#import "Header.h"
#import "SetViewController.h"
#import "TableViewCell.h"
#import "EditingViewController.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) UIPasteboard *pasteboard;
@property (nonatomic,strong) UIButton *headerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    NSString *title = NSLocalizedString(@"APPName", nil);
    self.title = title;
    self.tableView.backgroundColor = kBackgroundColor;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SecretGuide"]) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"SecretGuide"] isEqual:@5]) {
        }else {
            int old = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SecretGuide"] intValue];
            [[NSUserDefaults standardUserDefaults] setObject:@(old + 1) forKey:@"SecretGuide"];
            [self setTableHeaderView];
        }
    }else {
        [[NSUserDefaults standardUserDefaults] setObject:@1 forKey:@"SecretGuide"];
        [self setTableHeaderView];
    }
    
    self.pasteboard = [UIPasteboard generalPasteboard];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pasteboardChanged:) name:UIPasteboardChangedNotification object:nil];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"Set"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 20, 20);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 17, 17);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SecretData"]) {
        self.data = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"SecretData"]];
    }else {
        self.data = [NSMutableArray new];
    }
}

//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

- (void)setTableHeaderView {
    UILabel *headerView = [UILabel new];
    headerView.frame = CGRectMake(0, 0, self.view.width, 44);
    headerView.backgroundColor = kLightGrayColor;
    headerView.textColor = kTitleColor;
    headerView.font = kTitleFont;
    headerView.textAlignment = NSTextAlignmentCenter;
    headerView.text = NSLocalizedString(@"pasteboardInitString", nil);
    self.tableView.tableHeaderView = headerView;
}

- (void)reloadData {
    [self.tableView reloadData];
}

#pragma mark -

- (void)leftButtonAction:(UIButton *)sender {
    SetViewController *setVC = [SetViewController new];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:setVC];
    [nc.navigationBar setTitleTextAttributes:@{
                                               NSForegroundColorAttributeName:[UIColor colorWithRed:109/255.0 green:109/255.0 blue:109/255.0 alpha:1.0],
                                               NSFontAttributeName:[UIFont boldSystemFontOfSize:18]
                                               }];
    [self.navigationController presentViewController:nc animated:YES completion:^{
    }];
}

- (void)rightButtonAction:(UIButton *)sender {
    EditingViewController *evc = [EditingViewController new];
    evc.saveData = nil;
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(evc) weakEvc = evc;
    evc.addData = ^(){
        [weakSelf.data addObject:weakEvc.saveData];
        [self reloadAndSaveData];
    };
    
    [self.navigationController pushViewController:evc animated:YES];
}

- (void)pasteboardChanged:(NSNotification *)sender {
    [self.headerView setTitle:self.pasteboard.string forState:UIControlStateNormal];
    if (self.pasteboard.string.length > 0) {
        self.headerView.backgroundColor = kWhiteColor;
    }else {
        [UIView animateWithDuration:0.4 animations:^{
            self.headerView.backgroundColor = kGreenColor;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)clean:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = @"";
}

- (void)reloadAndSaveData {
    [self reloadData];
    [[NSUserDefaults standardUserDefaults] setObject:self.data forKey:@"SecretData"];
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44 + 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44 + 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.headerView setTitle:self.pasteboard.string forState:UIControlStateNormal];
    [self.headerView setTitleColor:kTitleColor forState:UIControlStateNormal];
    self.headerView.titleLabel.font = kTitleFont;
    [self.headerView addTarget:self action:@selector(clean:) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.frame = CGRectMake(0, 0, self.view.width, 44 + 3);
    if (self.pasteboard.string.length > 0) {
        self.headerView.backgroundColor = kWhiteColor;
    }else {
        [UIView animateWithDuration:0.4 animations:^{
            self.headerView.backgroundColor = kGreenColor;
        } completion:^(BOOL finished) {
        }];
    }
    
    return self.headerView;
}

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.contentView.backgroundColor = kBackgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.buttonsData = self.data[indexPath.row];
    
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *RowAction0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Edit", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        EditingViewController *evc = [EditingViewController new];
        __weak typeof(self) weakSelf = self;
        __weak typeof(evc) weakEvc = evc;
        
        evc.saveData = self.data[indexPath.row];
        evc.addData = ^(){
            if (weakEvc.saveData.count == 0) {
                [self deleteRowsAtIndexPaths:indexPath];
            }else {
                [weakSelf.data replaceObjectAtIndex:indexPath.row withObject:weakEvc.saveData];
                [self reloadAndSaveData];
            }
        };
        [self.navigationController pushViewController:evc animated:YES];
    }];
    UITableViewRowAction *RowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self deleteRowsAtIndexPaths:indexPath];
    }];
    RowAction0.backgroundColor = [UIColor colorWithRed:199/255.0 green:199/255.0 blue:204/255.0 alpha:1.0];
    RowAction1.backgroundColor = [UIColor colorWithRed:252/255.0 green:61/255.0 blue:57/255.0 alpha:1.0];
    return @[RowAction1,RowAction0];
}

- (void)deleteRowsAtIndexPaths:(NSIndexPath *)indexPath {
    [self.data removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [[NSUserDefaults standardUserDefaults] setObject:self.data forKey:@"SecretData"];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
