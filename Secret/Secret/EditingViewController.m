//
//  EditingViewController.m
//  Secret
//
//  Created by 郭旭赞 on 2017/1/9.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import "EditingViewController.h"
#import "EditingCell.h"
#import "Header.h"

@interface EditingViewController ()

{
    NSArray *_initData;
}

@end

@implementation EditingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.title = NSLocalizedString(@"Edit", nil);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = kBackgroundColor;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 17, 17);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 17, 17);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)setSaveData:(NSMutableArray *)saveData {
    if (saveData.count == 0) {
        NSMutableDictionary *item = [NSMutableDictionary new];
        [item setObject:@"" forKey:kTitle];
        [item setObject:@"" forKey:kContent];
        _saveData = [[NSMutableArray alloc] initWithObjects:item, nil];
    }else {
        _saveData = [[NSMutableArray alloc] initWithArray:saveData copyItems:YES];
    }
    _initData = [[NSArray alloc] initWithArray:_saveData copyItems:YES];
    self.buttonsData = [[NSMutableArray alloc] initWithArray:_saveData copyItems:YES];
}

- (void)save:(UIButton *)sender {
    _saveData = [[NSMutableArray alloc] initWithArray:self.buttonsData copyItems:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        sender.backgroundColor = kLightGrayColor;
    } completion:^(BOOL finished) {
        sender.backgroundColor = kWhiteColor;
    }];
}

- (void)leftButtonAction:(UIButton *)sender {
    if (![_initData isEqualToArray:self.saveData]) {
        self.addData();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightButtonAction:(UIButton *)sender {
    NSMutableDictionary *item = [NSMutableDictionary new];
    [item setObject:@"" forKey:kTitle];
    [item setObject:@"" forKey:kContent];
    [self.buttonsData addObject:item];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIButton *header = [UIButton buttonWithType:UIButtonTypeCustom];
    [header setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
    [header setTitleColor:kTitleColor forState:UIControlStateNormal];
    header.titleLabel.font = kTitleFont;
    header.backgroundColor = kWhiteColor;
    [header addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];
    header.frame = CGRectMake(0, 0, self.view.width, 44);
    
    return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.buttonsData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    EditingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[EditingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.item = self.buttonsData[indexPath.row];
    __weak typeof(self) weakSelf = self;
    cell.getCellData = ^(NSMutableDictionary *item){
        [weakSelf.buttonsData replaceObjectAtIndex:indexPath.row withObject:item];
//        [weakSelf.tableView reloadData];
    };
    
    return cell;
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *RowAction0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:NSLocalizedString(@"Delete", nil) handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self.buttonsData removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    RowAction0.backgroundColor = [UIColor colorWithRed:252/255.0 green:61/255.0 blue:57/255.0 alpha:1.0];
    return @[RowAction0];
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
