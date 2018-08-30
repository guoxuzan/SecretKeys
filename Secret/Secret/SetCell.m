//
//  SetCell.m
//  Secret
//
//  Created by 郭旭赞 on 2017/1/14.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import "SetCell.h"

@implementation SetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.authenticationSwitch = [UISwitch new];
        self.accessoryView = self.authenticationSwitch;
    }
    return self;
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
