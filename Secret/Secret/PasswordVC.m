//
//  PasswordVC.m
//  Secret
//
//  Created by 郭旭赞 on 2017/1/14.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import "PasswordVC.h"
#import "Header.h"

@interface PasswordVC ()

@property (nonatomic,strong) UITextField *textField0;
@property (nonatomic,strong) UITextField *textField1;
@property (nonatomic,strong) UIButton *doneButton;

@end

@implementation PasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:[UIImage imageNamed:@"Back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.frame = CGRectMake(0, 0, 17, 17);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.view.backgroundColor = kBackgroundColor;
    
    self.textField0 = [UITextField new];
    self.textField0.frame = CGRectMake(0, 64 + 15, self.view.width, 35);
    self.textField0.backgroundColor = kWhiteColor;
    self.textField0.textColor = kTitleColor;
    self.textField0.font = kTitleFont;
    self.textField0.textAlignment = NSTextAlignmentCenter;
    [self.textField0 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.textField0];
    
    self.textField1 = [UITextField new];
    self.textField1.frame = CGRectMake(0, self.textField0.bottom + 15, self.view.width, 35);
    self.textField1.backgroundColor = kWhiteColor;
    self.textField1.textColor = kTitleColor;
    self.textField1.font = kTitleFont;
    self.textField1.textAlignment = NSTextAlignmentCenter;
    [self.textField1 addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:self.textField1];
    
    self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.doneButton.frame = CGRectMake((self.view.width - 180)/2, self.textField1.bottom + 15, 180, 35);
    self.doneButton.backgroundColor = kWhiteColor;
    [self.doneButton setTitleColor:kTitleColor forState:UIControlStateNormal];
    self.doneButton.titleLabel.font = kTitleFont;
    self.doneButton.layer.cornerRadius = 5;
    [self.doneButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(doneButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.doneButton];
}

- (void)doneButtonAction:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        sender.backgroundColor = kLightGrayColor;
    } completion:^(BOOL finished) {
        sender.backgroundColor = kWhiteColor;
    }];
    if ((self.textField0.text.length != 0) && [self.textField0.text isEqualToString:self.textField1.text]) {
        [[NSUserDefaults standardUserDefaults] setObject:self.textField0.text forKey:@"SecretPassword"];
        [sender setTitle:NSLocalizedString(@"Success", nil) forState:UIControlStateNormal];
    }else {
        if (self.textField0.text.length == 0) {
            [sender setTitle:NSLocalizedString(@"BlankPassword", nil) forState:UIControlStateNormal];
        }
        if (![self.textField0.text isEqualToString:self.textField1.text]) {
            [sender setTitle:NSLocalizedString(@"PasswordsMustMatch", nil) forState:UIControlStateNormal];
        }
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    [self.doneButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
}

- (void)leftButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
