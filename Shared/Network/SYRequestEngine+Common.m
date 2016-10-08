//
//  SYRequest+Common.m
//  Soouya
//
//  Created by hetao on 16/7/25.
//  Copyright © 2016年 Soouya. All rights reserved.
//

#import "SYRequestEngine+Common.h"
#import "UIImage+SYScale.h"
#import "NSString+MD5Addition.h"

// 文件上传路径
static NSString * const kUploadFilePath                        = @"/uploadFile";

@implementation SYRequestEngine (Common)

+ (void)uploadImage:(UIImage *)image callback:(AZNetworkResultBlock)callback
{
    [SYNetworkManager startRequestWithUrl:RequestUrlFactory(kUploadFilePath)
                                   method:SYRequestMethodPost
                                   params:nil
                                     body:^(id<AFMultipartFormData> formData) {
                                         if (image) {
                                             NSData *imgData = [image compressToUpload];

                                             NSString *timestamp = [[NSString randomTimestamp] stringFromMD5];
                                             [formData appendPartWithFileData:imgData
                                                                         name:@"file"
                                                                     fileName:[NSString stringWithFormat:@"%@.jpg", timestamp]
                                                                     mimeType:@"image/jpg"];
                                             [formData appendPartWithFormData:[@"file" dataUsingEncoding:NSUTF8StringEncoding]
                                                                         name:@"field"];
                                         }
                                     }
                                 callback:callback];
}


+ (NSArray *)imagesDataFromImages:(NSArray *)images
{
    NSMutableArray *imgDatas = [NSMutableArray arrayWithCapacity:images.count];
    
    for (UIImage *img in images) {
        [imgDatas addObject:[img compressToUpload]];
    }
    
    return imgDatas;
}

@end
