//
//  LocalAuthenticationViewController.m
//  Secret
//
//  Created by 郭旭赞 on 2017/1/11.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import "LocalAuthenticationViewController.h"
#import "Header.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface LocalAuthenticationViewController ()

@property (nonatomic,strong) UIButton *againButton;
@property (nonatomic,strong) UITextField *passwordTextField;
@property (nonatomic,strong) UIButton *doneButton;

@end

@implementation LocalAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kBackgroundColor;
    
    if (self.isTouchID) {
        self.againButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.againButton.frame = CGRectMake(0, 0, 140, 35);
        self.againButton.center = CGPointMake(self.view.centerX, self.view.centerY);
        [self.againButton addTarget:self action:@selector(againAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.againButton setTitle:NSLocalizedString(@"TouchID", nil) forState:UIControlStateNormal];
        self.againButton.layer.cornerRadius = 5;
        self.againButton.backgroundColor = kGreenColor;
        [self.view addSubview:self.againButton];
        
        [self TouchID];
    }
    
    if (self.isPassword) {
        self.passwordTextField = [UITextField new];
        self.passwordTextField.frame = CGRectMake(0, 64 + 20, self.view.width, 35);
        self.passwordTextField.backgroundColor = kWhiteColor;
        self.passwordTextField.textColor = kTitleColor;
        self.passwordTextField.font = kTitleFont;
        self.passwordTextField.textAlignment = NSTextAlignmentCenter;
        [self.passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        [self.view addSubview:self.passwordTextField];
        
        self.doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.doneButton.frame = CGRectMake((self.view.width - 140)/2, self.passwordTextField.bottom + 20, 140, 35);
        [self.doneButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.doneButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
        self.doneButton.layer.cornerRadius = 5;
        self.doneButton.backgroundColor = kGreenColor;
        [self.view addSubview:self.doneButton];
    }
}

- (void)againAction:(UIButton *)sender {
    [self TouchID];
}

- (void)TouchID {
    LAContext *context = [LAContext new];
    NSError *error;
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:NSLocalizedString(@"TouchID", nil) reply:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                [self dismissViewControllerAnimated:NO completion:^{
                }];
            }else {
            }
        }];
    }
}

- (void)doneAction:(UIButton *)sender {
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"SecretPassword"];
    if ([self.passwordTextField.text isEqualToString:password]) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }else {
        [sender setTitle:NSLocalizedString(@"WrongPassword", nil) forState:UIControlStateNormal];
    }
}

- (void)textFieldDidChange:(UITextField *)textField {
    [self.doneButton setTitle:NSLocalizedString(@"OK", nil) forState:UIControlStateNormal];
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
