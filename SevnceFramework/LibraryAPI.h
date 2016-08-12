//
//  LibraryAPI.h
//  FrameworkTest
//
//  Created by 郭炜 on 16/8/12.
//  Copyright © 2016年 郭炜. All rights reserved.
//

#ifndef LibraryAPI_h
#define LibraryAPI_h
///**
// *  正式环境
// */
//#define API_HOST @"http://123.59.61.167/api/JNWTV"

///**
// *   测试环境
// */
#define API_HOST @"http://192.168.1.133"

//      接口路径全拼
#define PATH(_path)             [NSString stringWithFormat:_path, API_HOST]
/**
 *      首页
 */
#define DEF_GetHomepage         PATH(@"%@/Task/listTask.json")

/**
 *      上传头像
 */
#define DEF_UploadHeadImg       PATH(@"%@/UploadHeadImg")





#endif /* LibraryAPI_h */
