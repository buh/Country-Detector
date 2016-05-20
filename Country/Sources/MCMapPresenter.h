//
//  MCMapPresenter.h
//  Country
//
//  Created by Alexey Bukhtin on 29.03.16.
//  Copyright © 2016 The Mobile Company. All rights reserved.
//

#import "MCCountryViewModel.h"
#import "ReactiveCocoa.h"

@interface MCMapPresenter : NSObject

@property (nonatomic, readonly) MCCountryViewModel *countryViewModel;
@property (nonatomic, readonly) RACCommand *searchCountryCommand;

@end
