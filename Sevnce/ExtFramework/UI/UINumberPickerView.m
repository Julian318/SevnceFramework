//
//  UIDigitPickerView.m
//  易聚
//
//  Created by imac on 15/5/3.
//  Copyright (c) 2015年 mmchat. All rights reserved.
//

#import "UINumberPickerView.h"
@interface UINumberPickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    NSInteger digitNumber;
}
@end

@implementation UINumberPickerView
-(id)init{
    self=[super init];
    if(self){
        self.dataSource=self;
        self.delegate=self;
        digitNumber=2;
    }
    return self;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return digitNumber;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld",(long)row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    _value=0;
    long mul=1;
    for(long i=digitNumber-1;i>=0;i--){
        long selectedRow = [pickerView selectedRowInComponent:i];
        _value+=mul*selectedRow;
        mul*=10;
    }
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 30;
}
-(void)setValue:(long long)value{
    _value=value;
    for(long i=digitNumber-1;i>=0;i--){
        long temp=value%10;
        [self selectRow:temp inComponent:i animated:NO];
        value/=10;
    }
}
@end
