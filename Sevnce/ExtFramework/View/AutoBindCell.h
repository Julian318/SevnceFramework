

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "BaseDataModel.h"
#import "StyledTableViewCell.h"
#import "UIView+Extension.h"

@interface AutoBindCell : StyledTableViewCell
@property (retain, nonatomic) UITableView *tableView;
@property (retain, nonatomic) NSIndexPath *indexPath;
@property (nonatomic, retain) id heightChanged;
@property (retain, nonatomic) BaseDataModel *Data;
-(void)adjustCell;
-(void)handleData:(BaseDataModel*)data;
@end
