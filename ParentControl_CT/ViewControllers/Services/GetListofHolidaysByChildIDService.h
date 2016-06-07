//
//  GetListofHolidaysByChildIDService.h
//  ParentControl_CT
//
//  Created by Yogesh on 09/01/16.
//  Copyright © 2016 ImagineInteractive. All rights reserved.
//

#import "UrlConnection.h"

@interface GetListofHolidaysByChildIDService : UrlConnection<UrlConnectionDelegate>
-(void)initService:(NSDictionary *)dictionary;
@end
