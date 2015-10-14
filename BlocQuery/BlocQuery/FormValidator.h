//
//  FormValidator.h
//  BlocQuery
//
//  Created by Weinan Qiu on 2015-10-13.
//  Copyright © 2015 Kumiq. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FormValidator <NSObject>

+ (id <FormValidator>) validator;

- (BOOL) isFormValid:(NSDictionary *)form errors:(NSArray **)errors;

@end
