//
//  BaseHorizontalConllectionview.m
//  SingaporeBusiness
//
//  Created by crly on 16/2/26.
//  Copyright © 2015年 sevnce. All rights reserved.
//

#import "BaseCollectionview.h"
#import "BaseDataModel.h"
#import "AutoBindCollectionCell.h"
#import "SDRefresh.h"

@implementation BaseCollectionview
{
    NSMutableArray *mdataSource;
    NSString *CellIdentifier;
    Class _cls;
}

- (instancetype)init
{
    //创建流水布局对象
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
//    layout.itemSize =  CGSizeMake((screenwidth-50)/5, 94);
//    //设置水平滚动
//    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    //    // 设置cell之间间距
//    layout.minimumInteritemSpacing = 0;
//    //    // 设置行距
//    layout.minimumLineSpacing = 0;
    
    return [super initWithCollectionViewLayout:layout];
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

-(void)setAction:(NSString *)action{
    if(!_action){
        _action=action;
        [self refresh];
    }else
        _action=action;
}


-(void)setDataSource1:(NSArray *)dataSource1{
    
    mdataSource=[NSMutableArray arrayWithArray:dataSource1];
    
    Class tempClass = self.modelClass;
    for (int i=0;i<mdataSource.count;i++) {
        if([mdataSource[i] class] == tempClass)continue;
        BaseDataModel* model;
        if(tempClass){
            model=[[tempClass alloc]init];
            [model updateWithData:mdataSource[i]];
        }else{
            model=[self modelWithData:mdataSource[i]];
        }
        if(model)mdataSource[i]=model;
    }
    [self.collectionView reloadData];
}

-(void)setModelClass:(Class)cls{
    _cls=cls;
}

-(BaseDataModel*)modelWithData:(NSDictionary*)data{
    return nil;
}
-(Class)modelClass{
    return _cls;
}

-(void)refresh{
    [[HttpConnection new] startWithUrl:_action params:self.para?self.para:[NSDictionary new] block:^(id data){
        if(!data){
            //            [refreshHeader endRefreshing];
        }
        else if([data isKindOfClass:[NSDictionary class]]){
            NSDictionary* json=data;
            [self setDataSource1:[json objectForKey:@"list" ]];
        }
    }];
}

-(void)setCell:(Class)class Identifier:(NSString *)Identifier{
    CellIdentifier=Identifier;
    [self.collectionView registerClass:class
forCellWithReuseIdentifier:Identifier];
}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (self.rowcount==1) {
        return 1;
    }
    else{
        return ceil((float)mdataSource.count/self.rowcount);
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    if (self.rowcount==1) {
        return mdataSource.count;
    }
    else{
        NSInteger code=0;
        if ((mdataSource.count%self.rowcount)>0) {
            if (section==(ceil((float)mdataSource.count/self.rowcount)-1)) {
                code=mdataSource.count%self.rowcount;
            }
            else{
                code=self.rowcount;
            }
        }
        else{
            code=self.rowcount;
        }
        return code;
    }
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AutoBindCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    if([self modelClass]){
        BaseDataModel* data=[mdataSource objectAtIndex:indexPath.section*self.rowcount+indexPath.row];
        cell.Data=data;
    }
    return cell;
}


//选中某项时执行方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BaseDataModel* data=[mdataSource objectAtIndex:indexPath.section*self.rowcount+indexPath.row];
    if(self.listener&&[self.listener respondsToSelector:@selector(selectRowAtIndexPath:)]){
        [self.listener performSelector:@selector(selectRowAtIndexPath:) withObject:data];
    }
}


- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(_cellWidth,_cellHeight);
}

//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}


@end
