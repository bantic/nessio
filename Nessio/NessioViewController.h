//
//  NessioViewController.h
//  Nessio
//
//  Created by Cory Forsyth on 8/27/12.
//  Copyright (c) 2012 Cory Forsyth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRWebSocket.h"

@interface NessioViewController : UIViewController <SRWebSocketDelegate>
@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, strong) NSArray *buttonNames;
- (IBAction)doConnect:(id)sender;
- (IBAction)buttonUp:(id)sender;
- (IBAction)buttonDown:(id)sender;
-(void)sendPressButton:(NSString *)buttonName;
-(void)sendReleaseButton:(NSString *)buttonName;
@end
