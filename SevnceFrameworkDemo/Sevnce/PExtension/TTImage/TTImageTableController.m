//
//  TTImageTableController.m
//  MultiImagePickerDemo
//
//  Created by Jason Lee on 12-11-1.
//  Copyright (c) 2012年 Jason Lee. All rights reserved.
//

#import "TTImageTableController.h"
#import "TTAsset.h"
#import "TTImageTableCell.h"
#import "Util.h"

@interface TTImageTableController ()

@end

@implementation TTImageTableController


- (id)init
{
    self = [super init];
    if (self) {
        //
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

//- (void)dealloc
//{
//    [_assetsLibrary release];
//    [_assetsGroup release];
//    [_assetsArray release];
//    
//    [_tableView release];
//    [_bottomBar release];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    //
//    [super dealloc];
//}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"加载中";
    
    // Translate EnGroupName into CnGroupName
    NSString *groupName = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    if ([groupName isEqualToString:@"Camera Roll"]) {
        groupName = @"相机胶卷";
    } else if ([groupName isEqualToString:@"My Photo Stream"]) {
        groupName = @"我的照片流";
    }
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonDidClick:)];
    
    _tableView = [[UITableView alloc] initWithFrame:(CGRect){0, 0, screenwidth, screenheight-96} style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    _bottomBar = [[TTImagePickerBar alloc] initWithFrame:(CGRect){0, MaxY(_tableView), screenwidth, 96}];
    [self.view addSubview:self.bottomBar];
    
    // You can show loading here...
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self getImages];
        dispatch_async(dispatch_get_main_queue(), ^{
            // You can hide loading here...
            self.title = groupName;
            [self.tableView reloadData];
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (void)applicationWillEnterForeground
{
    // reload table if needed.
}

- (void)getImages
{
    if (!self.assetsArray) {
        _assetsArray = [[NSMutableArray alloc] init];
    }
    
    if (!self.assetsLibrary) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    
//    @autoreleasepool {
        [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                TTAsset *ttAsset = [[TTAsset alloc] initWithAsset:result];
                ttAsset.delegate = self;
                [self.assetsArray addObject:ttAsset];
                ttAsset = nil;
            }
        }];
//    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil([self.assetsGroup numberOfAssets] / 4.0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79.0f;   // The size of the thumbnail in iPhoto is (75, 75), with 4-pix margin to each other.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TTImageTableCell";
    TTImageTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[TTImageTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger idx;
    NSInteger num;
    if (DEVICE_IS_IPHONE6PLUS) {
        idx = indexPath.row * 5;
        num = 5;
    }else {
        idx = indexPath.row * 4;
        num = 4;
    }
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:num];
    for (int i = idx; i < [self.assetsArray count] && i < idx + num; ++i) {
        [array addObject:[self.assetsArray objectAtIndex:i]];
    }
    
    cell.assetsArray = array;
    cell.delegate = self;
    array = nil;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 

- (void)doneButtonDidClick:(id)sender
{
    [UIView setAnimationsEnabled:YES];
    if ([self.bottomBar.selectedAssets count] <= 0) {
        return ;
    }
    
    if (self.isUploading) {
        return ;
    }
    self.isUploading = YES;
    // You can show loading here...
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *imageInfoArray = [[NSMutableArray alloc] init];
        
//        @autoreleasepool {
            for (TTAsset *ttAsset in self.bottomBar.selectedAssets) {
                ALAsset *asset = ttAsset.asset;
                NSMutableDictionary *workingDictionary = [[NSMutableDictionary alloc] init];
                
                id propertyType = [asset valueForProperty:ALAssetPropertyType];
                if (propertyType) {
                    [workingDictionary setObject:propertyType forKey:@"UIImagePickerControllerMediaType"];
                } else {
                    continue;
                }
                
                UIImage *originalImage = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
                if (originalImage) {
                    [workingDictionary setObject:originalImage forKey:@"UIImagePickerControllerOriginalImage"];
                } else {
                    continue;
                }
                
                id referenceURL = [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]];
                if (referenceURL) {
                    [workingDictionary setObject:referenceURL forKey:@"UIImagePickerControllerReferenceURL"];
                } else {
                    continue;
                }
                
                [imageInfoArray addObject:workingDictionary];
            }
//        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // You can hide loading here...
            
            if ([imageInfoArray count] <= 0) {
                [self.bottomBar.selectedAssets removeAllObjects];
                [self.bottomBar reloadData];
                return ;
            }

            if (self.delegate &&
                [self.delegate respondsToSelector:@selector(didFinishPickingImages:)])
            {
                [self.delegate performSelector:@selector(didFinishPickingImages:) withObject:imageInfoArray];
            }
            
            self.isUploading = NO;
        });
    });
}

- (void)thumbnailDidClick:(TTAsset *)ttAsset
{
    if (ttAsset.selected) {
        [self.bottomBar addAsset:ttAsset];
    } else {
        [self.bottomBar removeAsset:ttAsset];
    }
}

@end
