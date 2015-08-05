//
//  SearchListCell.h
//  IpCameraClient
//
//  Created by jiyonglong on 12-4-26.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SearchListCell : UITableViewCell {
    
    IBOutlet UILabel *nameLabel;
    IBOutlet UILabel *addrLabel;
    IBOutlet UILabel *didLabel;

}

@property (nonatomic, retain)IBOutlet UILabel *nameLabel;
@property (nonatomic, retain)IBOutlet UILabel *addrLabel;
@property (nonatomic, retain)IBOutlet UILabel *didLabel;

@end
