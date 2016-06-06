//
//  BaseFragment.h
//  talkingroom
//
//  Created by imac on 13-12-22.
//  Copyright (c) 2013年 yanghong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AutoBindCell,BaseDataModel;
@interface BaseListView : UITableViewController{
    int _page;
    int _pageSize;
    int _pageCount;
    NSIndexPath* editingRow;
    NSMutableDictionary* cells;
    AutoBindCell* currentCell;
}
@property (retain, nonatomic) BaseDataModel *Data;
@property (retain, nonatomic) UITableViewCell *header;
@property (retain, nonatomic) NSMutableArray *dataSource;
@property (retain, nonatomic) NSDictionary *para;
@property (retain, nonatomic) NSString *action;
@property (retain, nonatomic) id listener;
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier;
-(void)setModelClass:(Class)cls;
-(Class)modelClass;
-(void)refresh;
- (void)refresh:(NSNotification*)notification;
-(void)didBeforeRefresh;
-(BaseDataModel*)modelWithData:(NSDictionary*)data;
- (int)sheetsNumberAtIndexPath:(NSIndexPath *)indexPath;
- (void)deleteAtIndexPath:(NSIndexPath *)indexPath;
- (void)editAtIndexPath:(NSIndexPath *)indexPath;
- (AutoBindCell*)getCellWithData:(NSString *)dataIdentifier;
@end
