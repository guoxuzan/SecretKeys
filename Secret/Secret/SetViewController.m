//
//  SetViewController.m
//  Secret
//
//  Created by 郭旭赞 on 2017/1/8.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import "SetViewController.h"
#import "Header.h"
#import "PasswordVC.h"
#import "SetCell.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface SetViewController ()

@property (nonatomic,copy) NSArray *data;
@property (nonatomic,copy) NSDictionary *action;
@property (nonatomic,copy) NSString *passwordShow;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = NSLocalizedString(@"Settings", nil);
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 17, 17);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"SecretPassword"]) {
        self.passwordShow = NSLocalizedString(@"SetPassword", nil);
    }else {
        self.passwordShow = NSLocalizedString(@"ModifyPassword", nil);
    }
    self.data = @[NSLocalizedString(@"Feedback", nil),
                  NSLocalizedString(@"Rate", nil),
                  NSLocalizedString(@"Backup", nil),
                  NSLocalizedString(@"Share", nil),
                  self.passwordShow,
                  @"TouchID",
                  NSLocalizedString(@"Password", nil)];
    self.action = @{
                    NSLocalizedString(@"Feedback", nil):@"emailMe",
                    NSLocalizedString(@"Rate", nil):@"evaluate",
                    NSLocalizedString(@"Backup", nil):@"backup",
                    NSLocalizedString(@"Share", nil):@"share",
                    self.passwordShow:@"password",
                    @"TouchID":@"none",
                    NSLocalizedString(@"Password", nil):@"none",
                    };
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.backgroundColor = kBackgroundColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftButtonAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 0;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    SetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.textLabel.textColor = kTitleColor;
        cell.textLabel.font = kTitleFont;
        cell.textLabel.backgroundColor = kWhiteColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = self.data[indexPath.row];
    
    if (indexPath.row == 5) {
        cell.authenticationSwitch.hidden = NO;
        cell.authenticationSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:kTouchIDSwitch] boolValue];
        [cell.authenticationSwitch addTarget:self action:@selector(touchIDSwitch:) forControlEvents:UIControlEventValueChanged];
    }else if(indexPath.row == 6) {
        cell.authenticationSwitch.hidden = NO;
        cell.authenticationSwitch.on = [[[NSUserDefaults standardUserDefaults] objectForKey:kPasswordSwitch] boolValue];
        [cell.authenticationSwitch addTarget:self action:@selector(passwordSwitch:) forControlEvents:UIControlEventValueChanged];
    }else {
        cell.authenticationSwitch.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SEL selector = NSSelectorFromString(self.action[self.data[indexPath.row]]);
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector withObject:nil];
    }
}

#pragma mark --

- (void)emailMe {
    if (![MFMailComposeViewController canSendMail]) {
        self.title = @"guoxuzan@gmail.com";
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = @"guoxuzan@gmail.com";
        return;
    }
    
    MFMailComposeViewController *mailComposeVC = [MFMailComposeViewController new];
    [mailComposeVC setToRecipients:@[@"guoxuzan@gmail.com"]];
    mailComposeVC.mailComposeDelegate = self;
    [self presentViewController:mailComposeVC animated:YES completion:^{
    }];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
    NSString *message;
    switch (result) {
        case MFMailComposeResultSent:
            message = @"";
            break;
        case MFMailComposeResultSaved:
            message = @"";
            break;
        case MFMailComposeResultCancelled:
            message = @"";
            break;
        case MFMailComposeResultFailed:
            message = @"";
            break;
            
        default:
            break;
    }
}

#pragma mark --
- (void)evaluate {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1195397069"]];
}

#pragma mark --
- (void)backup {
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path = [directory stringByAppendingString:@"Secret.csv"];
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:&error];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SecretData"]) {
        NSArray *secretArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"SecretData"];
        NSString *csvString = @"";
        for (int i=0; i < secretArray.count; i++) {
            NSArray *array = secretArray[i];
            for (int j=0; j < array.count; j++) {
                NSDictionary *dictionary = array[j];
                for (int k=0; k < dictionary.allValues.count; k++) {
                    csvString = [csvString stringByAppendingString:dictionary.allValues[k]];
                    if (k != 1) {
                        csvString = [csvString stringByAppendingString:@","];
                    }
                }
                csvString = [csvString stringByAppendingString:@"\n"];
            }
        }
        NSData *data = [csvString dataUsingEncoding:NSUTF8StringEncoding];
        
        if (![MFMailComposeViewController canSendMail]) {
            self.title = NSLocalizedString(@"CannotSendMail", nil);
            return;
        }
        
        MFMailComposeViewController *mailComposeVC = [MFMailComposeViewController new];
        [mailComposeVC addAttachmentData:data mimeType:@"text/csv" fileName:@"Secret.csv"];
        mailComposeVC.mailComposeDelegate = self;
        [self presentViewController:mailComposeVC animated:YES completion:^{
        }];
    }else {
        
    }
}

#pragma mark --
- (void)share {
    NSString *title = NSLocalizedString(@"APPName", nil);
    UIImage *image = [UIImage imageNamed:@"ShareAppIcon"];
    NSURL *URL = [NSURL URLWithString:@"https://itunes.apple.com/app/id1195397069"];
    NSArray *activityItems = @[title,image,URL];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    [self presentViewController:activityVC animated:YES completion:^{
    }];
}

#pragma mark --
- (void)password {
    if (!(self.navigationController.topViewController == self)) {
        return;
    }
    PasswordVC *passwordVC = [PasswordVC new];
    passwordVC.title = self.passwordShow;
    [self.navigationController pushViewController:passwordVC animated:YES];
}

- (void)none {
    
}

//todo 调2次
- (void)touchIDSwitch:(UISwitch *)authenticationSwitch {
    LAContext *context = [LAContext new];
    NSError *error;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
    }else {
        authenticationSwitch.on = NO;
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(authenticationSwitch.on) forKey:kTouchIDSwitch];
}

- (void)passwordSwitch:(UISwitch *)authenticationSwitch {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"SecretPassword"]) {
    }else {
        authenticationSwitch.on = NO;
        [self password];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@(authenticationSwitch.on) forKey:kPasswordSwitch];
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
