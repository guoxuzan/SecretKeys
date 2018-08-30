//
//  EditingViewController.h
//  Secret
//
//  Created by 郭旭赞 on 2017/1/9.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditingViewController : UITableViewController

@property (nonatomic,strong) NSMutableArray *buttonsData;
@property (nonatomic,strong) NSMutableArray *saveData;
@property (nonatomic,copy) void (^addData)();

@end
