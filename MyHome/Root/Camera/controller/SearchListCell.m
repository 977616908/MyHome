//
//  SearchListCell.m
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchListCell.h"


@implementation SearchListCell

@synthesize nameLabel;
@synthesize addrLabel;
@synthesize didLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
    self.nameLabel = nil;
    self.addrLabel = nil;
    self.didLabel = nil;
//    [super dealloc];
}


@end
