//
//  SSAPMessage.m
//  Sofia2iOS
//
//  Created by Adrián on 21/11/14.
//  Copyright (c) 2014 Indra. All rights reserved.
//

#import "SSAPMessage.h"
#import <Foundation/NSJSONSerialization.h>

@implementation SSAPMessage

-(id)initWithMessageId:(NSString *)messageId sessionKey:(NSString *)sessionKey ontology:(NSString *)ontology direction:(SSAPMessageDirection)direction messageType:(SSAPMessageType)messageType body:(NSDictionary *)body {
    
    if((self = [super init])) {
		_messageId = messageId;
        _sessionKey = sessionKey;
        _ontology = ontology;
        _direction = direction;
        _messageType = messageType;
        _body = body;
	}
	return self;
    
}


/**
 * Introduce todos los campos del mensaje SSAP en un diccionario que después se pasa a JSON.
 */
-(NSString *)getObjectInStringFormat {
    NSMutableDictionary *jsonDictionary = [[NSMutableDictionary alloc] init];
    
    //Si algun campo del mensaje SSAP es nil, en el JSON se insertara null
    if(_body) {
        [jsonDictionary setObject:_body forKey:kBody];
    }
    else {
        [jsonDictionary setObject:[NSNull null] forKey:kBody];
    }
    
    switch (_direction) {
    
        case REQUEST:
            [jsonDictionary setObject:@"REQUEST" forKey:kDirection];
            break;
            
        case RESPONSE:
            [jsonDictionary setObject:@"RESPONSE" forKey:kDirection];
            break;
            
        case ERROR:
            [jsonDictionary setObject:@"ERROR" forKey:kDirection];
            break;
            
        default:
            [jsonDictionary setObject:[NSNull null] forKey:kDirection];
            break;
    }
    
    if(_messageId) {
        [jsonDictionary setObject:_messageId forKey:kMessageId];
    }
    else {
        [jsonDictionary setObject:[NSNull null] forKey:kMessageId];
    }
    
    switch (_messageType) {
        case JOIN:
            [jsonDictionary setObject:@"JOIN" forKey:kMessageType];
            break;
            
        case LEAVE:
            [jsonDictionary setObject:@"LEAVE" forKey:kMessageType];
            break;
            
        case INSERT:
            [jsonDictionary setObject:@"INSERT" forKey:kMessageType];
            break;
            
        case UPDATE:
            [jsonDictionary setObject:@"UPDATE" forKey:kMessageType];
            break;
            
        case QUERY:
            [jsonDictionary setObject:@"QUERY" forKey:kMessageType];
            break;
            
        case SUBSCRIBE:
            [jsonDictionary setObject:@"SUBSCRIBE" forKey:kMessageType];
            break;
            
        case UNSUBSCRIBE:
            [jsonDictionary setObject:@"UNSUBSCRIBE" forKey:kMessageType];
            break;
            
        default:
            [jsonDictionary setObject:[NSNull null] forKey:kMessageType];
            break;
    }
    
    if(_ontology) {
        [jsonDictionary setObject:_ontology forKey:kOntology];
    }
    else {
        [jsonDictionary setObject:[NSNull null] forKey:kOntology];
    }
    
    if(_sessionKey) {
        [jsonDictionary setObject:_sessionKey forKey:kSessionKey];
    }
    else {
        [jsonDictionary setObject:[NSNull null] forKey:kSessionKey];
    }
    
    //El diccionario construido con los campos que va a tener el mensaje SSAP se pasa a JSON
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary options:0 error:&error];
    if (!jsonData) {
        NSLog(@"Error: %@", error);
        return nil;
    } else {
        //El JSON se pone en formato NSString
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return jsonString;
    }
}

@end
