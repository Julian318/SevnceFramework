//
//  BaseHorizontalConllectionview.h
//  SingaporeBusiness
//
//  Created by crly on 16/2/26.
//  Copyright © 2015年 sevnce. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCollectionview : UICollectionViewController//<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (retain, nonatomic) id listener;
@property (retain, nonatomic) NSDictionary *para;
@property (retain, nonatomic) NSString *action;
@property float cellWidth,cellHeight;
@property NSInteger rowcount;

-(void)setDataSource1:(NSArray *)dataSource1;
-(void)setCell:(Class)class Identifier:(NSString *)Identifier;
-(void)setModelClass:(Class)cls;
-(Class)modelClass;
-(void)refresh;

@end
