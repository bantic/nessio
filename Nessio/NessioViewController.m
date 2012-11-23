//
//  NessioViewController.m
//  Nessio
//
//  Created by Cory Forsyth on 8/27/12.
//  Copyright (c) 2012 Cory Forsyth. All rights reserved.
//

#import "NessioViewController.h"

#import "SRWebSocket.h"

@implementation NessioViewController


@synthesize webSocket, buttonNames;

- (void)viewDidLoad
{
    [super viewDidLoad];
    buttonNames = [NSArray arrayWithObjects:@"select", @"start", @"up", @"down", @"left", @"right", @"a", @"b", nil];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    NSLog(@"WS message: %@", message);
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"WS didOpen");
}
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"WS didFail to Open with error: %@", error);
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"WS didClose with code, reason, wasClean %d %@ %i", code, reason, wasClean);
}

- (IBAction)doConnect:(id)sender {
/*    webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://localhost:9000/chat"]]];
 */
    NSURL *url = [NSURL URLWithString:@"http://192.168.0.16.xip.io:3000/socket.io/1/?t=1346159907777"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    NSError *requestError;
    NSURLResponse *urlResponse = nil;
    
    NSData *response1 = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&requestError];
    if (!requestError) {
        NSString *responseString = [[NSString alloc] initWithData:response1 encoding:NSUTF8StringEncoding];
        NSLog(@"response body %@", responseString);
        
        NSArray *pieces = [responseString componentsSeparatedByString:@":"];
        NSString *wsID = [pieces objectAtIndex: 0];
        NSLog(@"ws id: %@", wsID);
        NSString *wsURL = [NSString stringWithFormat:@"ws://192.168.0.16.xip.io:3000/socket.io/1/websocket/%@", wsID];
        webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:wsURL]]];
        [webSocket setDelegate:self];
        
        NSLog(@"opening ws...");
        [webSocket open];
    } else {
        NSLog(@"error %@", requestError);
    }
}

- (IBAction)buttonDown:(id)sender {
    NSString *btnName = [buttonNames objectAtIndex:[sender tag]];
    NSLog(@"button down: %@", btnName);
    [self sendPressButton:btnName];
}

- (IBAction)buttonUp:(id)sender {
    NSString *btnName = [buttonNames objectAtIndex:[sender tag]];
    NSLog(@"button up: %@", btnName);
    [self sendReleaseButton:btnName];
}

-(void)sendPressButton:(NSString *)buttonName {
    NSString *msg = [NSString stringWithFormat:@"5:::{\"name\":\"c\",\"args\":[{\"p\":[\"%@\"],\"r\":[]}]}", buttonName];
    //NSLog(@"sending button press: %@", msg);
    [webSocket send:msg];
}
-(void)sendReleaseButton:(NSString *)buttonName {
    NSString *msg = [NSString stringWithFormat:@"5:::{\"name\":\"c\",\"args\":[{\"p\":[],\"r\":[\"%@\"]}]}", buttonName];
    //NSLog(@"sending button release: %@", msg);
    [webSocket send:msg];
}
@end
