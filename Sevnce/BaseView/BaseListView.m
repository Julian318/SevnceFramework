//
//  BaseFragment.m
//  talkingroom
//
//  Created by imac on 13-12-22.
//  Copyright (c) 2013年 yanghong. All rights reserved.
//

#import "BaseListView.h"
#import "HttpConnection.h"
#import "SDRefresh.h"
#import "BaseDataModel.h"
#import "AutoBindCell.h"
#import "RegisterUser.h"
#import "UIView+Toast.h"

@interface BaseListView ()<UIActionSheetDelegate>{
    SDRefreshHeaderView *refreshHeader;
    SDRefreshFooterView* refreshFooter;
    Class _cls;
    NSString *CellIdentifier;
}

@end

@implementation BaseListView
-(void)setDataSource:(NSArray *)dataSource{
    _dataSource=[NSMutableArray arrayWithArray:dataSource];
    Class tempClass = self.modelClass;
    for (int i=0;i<_dataSource.count;i++) {
        if([_dataSource[i] class] == tempClass)continue;
        BaseDataModel* model;
        if(tempClass){
            model=[[tempClass alloc]init];
            [model updateWithData:_dataSource[i]];
        }else{
            model=[self modelWithData:_dataSource[i]];
        }
        if(model)_dataSource[i]=model;
    }
    [self.tableView reloadData];
}
- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier{
    CellIdentifier=identifier;
    [self.tableView registerClass:cellClass  forCellReuseIdentifier:(NSString *)identifier];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    refreshHeader = [SDRefreshHeaderView refreshView];
    [refreshHeader addTarget:self refreshAction:@selector(refresh)];
    [refreshHeader addToScrollView:self.tableView];
    if(self.action)[refreshHeader beginRefreshing];
    self.view.backgroundColor=[UIColor whiteColor];
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    longPressGr.minimumPressDuration = 1.0;
    [self.tableView addGestureRecognizer:longPressGr];
}
- (void)refresh:(NSNotification*)notification {
    [self.view makeToast:@"处理成功！" duration:2 position:@"center"];
    [self refresh];
}
-(void)setAction:(NSString *)action{
    if(!_action){
        _action=action;
        [refreshHeader beginRefreshing];
    }else
        _action=action;
}
-(void)setPara:(NSDictionary *)para{
    _para=para;
}
-(void)refresh{
    _page=1;
    [self didBeforeRefresh];
    [[HttpConnection new] startWithUrl:_action params:self.para?self.para:[NSDictionary new] block:^(id data){
        if(!data){
            [refreshHeader endRefreshing];
        }
        else if([data isKindOfClass:[NSDictionary class]]){
            NSDictionary* json=data;
            if([json objectForKey:@"pageCount"]){
                _pageCount=((NSString*)[json objectForKey:@"pageCount"]).intValue;
                _page=((NSString*)[json objectForKey:@"page"]).intValue;
                if(_pageCount>_page){
                    refreshFooter=[SDRefreshFooterView refreshView];
                    [refreshFooter addTarget:self refreshAction:@selector(loadMore)];
                    [refreshFooter addToScrollView:self.tableView];
                }
            }
            [self setDataSource:[json objectForKey:@"list" ]];
            [refreshHeader endRefreshing];
        }
    }];
}
-(void)setModelClass:(Class)cls{
    _cls=cls;
    if(_cls){
        NSString* modelName=[NSString stringWithFormat:@"%@",[self modelClass]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:[NSString stringWithFormat:@"addOrDelete%@",modelName] object:nil];
    }
}
-(BaseDataModel*)modelWithData:(NSDictionary*)data{
    return nil;
}
-(Class)modelClass{
    return _cls;
}
-(void)didBeforeRefresh{}
-(void)loadMore{
    [[HttpConnection new] startWithUrl:[NSString stringWithFormat:@"%@?sevpagespage=%d&sevpagecount=20",_action,_page+1] params:self.para?self.para:[NSDictionary new] block:^(id data){
        if(!data){
            [refreshFooter endRefreshing];
        }else if([data isKindOfClass:[NSDictionary class]]){
            [refreshFooter endRefreshing];
            NSDictionary* json=data;
            if([json objectForKey:@"pageCount"]){
                _pageCount=((NSString*)[json objectForKey:@"pageCount"]).intValue;
                _page=((NSString*)[json objectForKey:@"page"]).intValue;
                if(_pageCount==_page){
                    [refreshFooter removeFromSuperview];
                    refreshFooter=nil;
                }
            }
            NSArray* list=[json objectForKey:@"list"];
            for(int i=0;i<list.count;i++){
                BaseDataModel* model;
                Class tempClass = self.modelClass;
                if(tempClass){
                    model=[[tempClass alloc]init];
                    [model updateWithData:list[i]];
                }else{
                    model=[self modelWithData:list[i]];
                }
                if(model)[self.dataSource addObject:model];
                else [self.dataSource addObject:list[i]];
            }
            [self.tableView reloadData];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(self.header)return 2;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.header){
        if(section==0)return 1;
    }
    return [self.dataSource count];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BaseDataModel* data=[self.dataSource objectAtIndex:[indexPath row]];
    if(self.listener&&[self.listener respondsToSelector:@selector(selectRowAtIndexPath:)]){
        [self.listener performSelector:@selector(selectRowAtIndexPath:) withObject:data];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if(self.header&&indexPath.section==0)return self.header;
    AutoBindCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if([self modelClass]){
        BaseDataModel* data=[self.dataSource objectAtIndex:[indexPath row]];
        cell.Data=data;
    }
    return cell;
}
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if(gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [gesture locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:point];
        if(indexPath == nil) return ;
        [self didLongPressAtIndexPath:indexPath];
    }
}
- (void)didLongPressAtIndexPath:(NSIndexPath *)indexPath{
    int sheets=[self sheetsNumberAtIndexPath:indexPath];
    UIActionSheet *chooseSheet;
    switch (sheets) {
        case 1:
            chooseSheet = [[UIActionSheet alloc] initWithTitle:@"操作选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
            break;
        case 2:
            chooseSheet = [[UIActionSheet alloc] initWithTitle:@"操作选择" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除",@"修改", nil];
            break;
        default:
            break;
    }
    [chooseSheet showInView:self.view.window];
    editingRow=indexPath;
}
- (int)sheetsNumberAtIndexPath:(NSIndexPath *)indexPath{
    if(self.header){
        if(indexPath.section==0)return 0;
    }
    BaseDataModel* data=self.dataSource[indexPath.row];
    if(data.User==[RegisterUser loggedUser])return 2;
    return 0;
}
- (void)deleteAtIndexPath:(NSIndexPath *)indexPath{
    editingRow=nil;
}
- (void)editAtIndexPath:(NSIndexPath *)indexPath{
    editingRow=nil;
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self deleteAtIndexPath:editingRow];
            break;
        case 1:
            [self editAtIndexPath:editingRow];
            break;
        default:
            return;
    }
}
- (AutoBindCell*)getCellWithData:(NSString *)dataIdentifier{
    if(!cells){
        cells=[NSMutableDictionary new];
        return nil;
    }
    return cells[dataIdentifier];
}
- (BaseDataModel*)getDataAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
