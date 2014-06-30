//
//  O1Datasource.h
//  O1ClientViewer
//
//  Created by Ji Fang on 6/29/14.
//
//

#import <Foundation/Foundation.h>

@class O1Datasource;

@protocol O1DatasourceDelegate <NSObject>

@required

- (void)sessionBitmapContextWillChange:(O1Datasource *)session;
- (void)sessionBitmapContextDidChange:(O1Datasource *)session;

@end

@interface O1Datasource : NSObject

@property (nonatomic, weak) id<O1DatasourceDelegate>	delegate;
@property (nonatomic, assign) CGContextRef				bitmapContext;
@property (nonatomic, assign) NSInteger					frequency;

- (id)initWithFrequency:(NSInteger)frequency;

@end
