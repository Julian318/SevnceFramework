
#import "AutoBindCell.h"
#import "AsyImageView.h"
#import "Image.h"
#import "UIView+Extension.h"
#import "UserPhoto.h"
@interface AutoBindCell(){
    void (^loadSuccess) ();
    CGFloat cellHeight;
}
@end

@implementation AutoBindCell
static NSMutableDictionary* allProperties;

-(NSMutableArray*)properties{
    if(!allProperties){
        allProperties=[NSMutableDictionary new];
    }
    NSString* class=[NSString stringWithFormat:@"%@",self.class];
    NSMutableArray *_properties=allProperties[class];
   if(!_properties){
        u_int count;
        objc_property_t* properties = class_copyPropertyList([self class], &count);
        _properties=[[NSMutableArray alloc]initWithCapacity:count];
        for (int i = 0; i < count ; i++)
        {
            objc_property_t property = properties[i];
            NSString *key=[[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding]; ;
            NSLog(@"%@",key);
            id value=[self valueForKey:key];            
            if (value) {
                [_properties addObject:key];
            }
        }
        free(properties);
        allProperties[class]=_properties;
    }
    return _properties;
}
-(void)handleData:(BaseDataModel*)data{
    id value;
    cellHeight=self.bounds.size.height;
    NSMutableArray *_properties=[self properties];
    for(NSString *key in _properties){
        UIView *control=[self valueForKey:key];//[_properties objectForKey:key];
        @try {
            value=[data valueForKey:key];
        }
        @catch (NSException *exception) {
            value=[data getValueWithKey:key];
        }
        if(!value)continue;
        value=[NSString stringWithFormat:@"%@",value];
        @try {
            if(control.Format){
                value=[NSString stringWithFormat:control.Format,value];
            }
        }
        @catch (NSException *exception) {
        }
        if([control isKindOfClass:[UIButton class]]){
            [((UIButton*)control) setTitle:value forState:UIControlStateNormal];
        }else if([control isKindOfClass:[UILabel class]]){
            ((UILabel*)control).text=value;
        }
        else if([control isKindOfClass:[UITextField class]]){
            ((UITextField*)control).text=value;
        }
        else if([control isKindOfClass:[UITextView class]]){
            ((UITextView*)control).text=value;
        }
//        else if([control isKindOfClass:[UserPhoto class]]){
//            if(value)((UserPhoto*)control).User=value;
//        }
        else if([control isKindOfClass:[AsyImageView class]]){
            if([value isKindOfClass:[Image class]]){
            }else{
                ((AsyImageView*)control).url=value;
            }
        }
    }
    [self layoutSubviews];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    if(self.superview && cellHeight!=self.bounds.size.height)[self adjustCell];
}
-(void)setData:(BaseDataModel *)Data{
    if(_Data==Data)return;
    if(_Data)[_Data removeDataChangedListener:self];
    _Data=Data;
    if(_Data)[_Data addDataChangedListener:self];
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if(nil==newSuperview){
        if(_Data)[_Data removeDataChangedListener:self];
    }else{
        if(_Data)[_Data addDataChangedListener:self];
    }
}
- (void)prepareForReuse{
    [super prepareForReuse];
    self.Data=nil;
}
-(void)adjustCell{
    if(self.hidden)return;
    NSLog(@"adjustCell:%@",self.superview);
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:self.indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    cellHeight=self.bounds.size.height;
}
-(void)dealloc{
    if(_Data)[_Data removeDataChangedListener:self];
}
@end
