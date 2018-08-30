//
//  EditingCell.m
//  Secret
//
//  Created by 郭旭赞 on 2017/1/9.
//  Copyright © 2017年 郭旭赞. All rights reserved.
//

#import "EditingCell.h"
#import "Header.h"

@implementation EditingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = kBackgroundColor;
        
        self.titleTextField = [UITextField new];
        self.titleTextField.textAlignment = NSTextAlignmentCenter;
        self.titleTextField.backgroundColor = kWhiteColor;
        self.titleTextField.textColor = kTitleColor;
        self.titleTextField.font = kTitleFont;
        self.titleTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.titleTextField.frame = CGRectMake(1, 30, kMainWidth - 2, 30);
        self.titleTextField.placeholder = NSLocalizedString(@"Title", nil);
        [self.contentView addSubview:self.titleTextField];
        
        self.contentTextView = [UITextView new];
        self.contentTextView.font = self.titleTextField.font;
        self.contentTextView.frame = CGRectMake(self.titleTextField.left, self.titleTextField.bottom + 10, self.titleTextField.width, self.titleTextField.height);
        self.contentTextView.backgroundColor = kWhiteColor;
        self.contentTextView.textColor = kTitleColor;
        self.contentTextView.font = kTitleFont;
        [self.contentView addSubview:self.contentTextView];
        
        [self.titleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.contentTextView.delegate = self;
    }
    return self;
}

- (void)setItem:(NSMutableDictionary *)item {
    _item = [[NSMutableDictionary alloc] initWithDictionary:item copyItems:YES];
    self.titleTextField.text = _item[kTitle];
    self.contentTextView.text = _item[kContent];
}

- (void)textFieldDidChange:(UITextField *)textField {
    [self.item setObject:self.titleTextField.text forKey:kTitle];
    self.getCellData(self.item);
}

- (void)textViewDidChange:(UITextView *)textView {
    [self.item setObject:self.contentTextView.text forKey:kContent];
    self.getCellData(self.item);
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
