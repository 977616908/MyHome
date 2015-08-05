//
// REPhotoThumbnailsCell.h
// REPhotoCollectionController
//
// Copyright (c) 2012 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import "REPhotoThumbnailView.h"
#import "REPhoto.h"
typedef enum {
    REPhotoNone=0x01,
    REPhotoMore,
    REPhotoPicker,
    REPhotoSelect,
    REPhotoOther
}REPhotoType;

@interface REPhotoThumbnailsCell : UITableViewCell {
    NSMutableArray *_photos;
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier ;
- (void)addPhoto:(REPhoto *)photo;
- (void)addPhotoWithArray:(NSArray *)arr;
- (void)removeAllPhotos;
- (void)refresh;
@property(nonatomic,strong)NSMutableOrderedSet *selectOrder;
@property(nonatomic,strong)NSArray *arryGroup;
@property(nonatomic,strong)id superController;
@property(nonatomic,assign) REPhotoType photoType;
@property(nonatomic,copy)NSDictionary *detailTitle;
@end
