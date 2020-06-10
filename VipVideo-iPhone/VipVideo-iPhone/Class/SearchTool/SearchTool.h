//
//  SearchTool.h
//  ProjectFrame
//
//  Created by Swift on 2018/5/25.
//  Copyright © 2018年 Swift. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchTool : NSObject

/**
 *  搜索数组，返回新的数组。目前支持NSString，NSDictionnary，自定义Model，后面两个可以指定按照哪个字段搜索
 *
 *  @param     originalArray      要搜索的数据源
 *  @param     searchText         搜索的文本
 *  @param     propertyName       按照字典中或者model中哪个字段搜索，如果数组中存的是NSString，则传@""即可
 *  @example   _dataSourceArray = [ZYPinYinSearch searchWithOriginalArray:_originalArray andSearchText:searchBar.text andSearchByPropertyName:@"name"];
 */
+(NSArray *)searchWithOriginalArray:(NSArray *)originalArray andSearchText:(NSString *)searchText andSearchByPropertyName:(NSString *)propertyName;

/**
 *  多字段匹配
 *
 *  @param originalArray      搜索的数据源
 *  @param searchText         搜索的文本
 *  @param propertyNamesArray 字典或者model中的哪几个字段搜索
 *
 *  @return 返回数组
 */
+(NSArray *)searchWithOriginalArray:(NSArray *)originalArray andSearchText:(NSString *)searchText andSearchByPropertyNames:(NSArray *)propertyNamesArray;

@end
