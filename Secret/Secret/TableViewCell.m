//
//  TableViewCell.m
//  Secret
//
//  Created by 郭旭赞 on 2017/1/8.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import "TableViewCell.h"
#import "Header.h"

@implementation TableViewCell

- (void)setButtonsData:(NSArray *)buttonsData {
    while (self.contentView.subviews.count > 0) {
        UIButton *button = [self.contentView viewWithTag:(1000 + self.contentView.subviews.count - 1)];
        [button removeFromSuperview];
    }
    
    _buttonsData = [buttonsData copy];
    
    for (int i = 0; i < _buttonsData.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = 1000 + i;
        CGFloat width = (kMainWidth - _buttonsData.count - 1)/_buttonsData.count;
        button.frame = CGRectMake(1+i*(width + 1), 4, width, 41);
        button.backgroundColor = kWhiteColor;
        NSDictionary *item = _buttonsData[i];
        [button setTitle:item[kTitle] forState:UIControlStateNormal];
        [button setTitleColor:kTitleColor forState:UIControlStateNormal];
        button.titleLabel.font = kTitleFont;
        button.layer.cornerRadius = 3;
        [self.contentView addSubview:button];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getContent:)];
        tapGestureRecognizer.numberOfTouchesRequired = 1;
        tapGestureRecognizer.numberOfTapsRequired = 1;
        [button addGestureRecognizer:tapGestureRecognizer];
    }
}

- (void)getContent:(UITapGestureRecognizer *)tapGestureRecognizer {
    UIButton *sender = (UIButton *)tapGestureRecognizer.view;
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSMutableDictionary *item = _buttonsData[sender.tag - 1000];
    pasteboard.string = item[kContent];
    
    [UIView animateWithDuration:0.3 animations:^{
        [sender setTitle:@"" forState:UIControlStateNormal];
        sender.backgroundColor = kGreenColor;
    } completion:^(BOOL finished) {
        [sender setTitle:item[kTitle] forState:UIControlStateNormal];
        sender.backgroundColor = kWhiteColor;
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
