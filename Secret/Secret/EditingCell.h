//
//  EditingCell.h
//  Secret
//
//  Created by 郭旭赞 on 2017/1/9.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditingCell : UITableViewCell<UITextViewDelegate>

@property (nonatomic,strong) NSMutableDictionary *item;
@property (nonatomic,strong) UITextField *titleTextField;
@property (nonatomic,strong) UITextView *contentTextView;
@property (nonatomic,copy) void (^getCellData)(NSMutableDictionary *item);

@end
