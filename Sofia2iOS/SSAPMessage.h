//
//  SSAPMessage.h
//  Sofia2iOS
//
//  Created by Adrián on 21/11/14.
//  Copyright (c) 2014 Indra. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kBody @"body"
#define kDirection @"direction"
#define kMessageId @"messageId"
#define kMessageType @"messageType"
#define kOntology @"ontology"
#define kSessionKey @"sessionKey"


@interface SSAPMessage : NSObject

/**
 * enumeracion que recoge todos los posibles valores del campo direction del mensaje SSAP.
 */
enum {
    REQUEST,
    RESPONSE,
    ERROR
};
typedef NSUInteger SSAPMessageDirection;

/**
 * enumeracion que recoge todos los posibles valores del campo messageType del mensaje SSAP.
 */
enum {
    JOIN,
    LEAVE,
    INSERT,
    UPDATE,
    QUERY,
    SUBSCRIBE,
    UNSUBSCRIBE
};
typedef NSUInteger SSAPMessageType;

/**
 * messageId del mensaje SSAP.
 */
@property (nonatomic, strong) NSString *messageId;

/**
 * sessionKey del mensaje SSAP.
 */
@property (nonatomic, strong) NSString *sessionKey;

/**
 * ontology del mensaje SSAP.
 */
@property (nonatomic, strong) NSString *ontology;

/**
 * direction del mensaje SSAP.
 */
@property (nonatomic,assign) SSAPMessageDirection direction;

/**
 * messageType del mensaje SSAP.
 */
@property (nonatomic,assign) SSAPMessageType messageType;

/**
 * body del mensaje SSAP en formato NSDictionary.
 */
@property (nonatomic, strong) NSDictionary *body;


/**
 * Inicialización del objeto de SSAPMessage
 *
 * @param messageId del mensaje SSAP.
 * @param sessionKey del mensaje SSAP.
 * @param ontology del mensaje SSAP.
 * @param direction del mensaje SSAP en formato SSAPMessageDirection.
 * @param messageType del mensaje SSAP en formato SSAPMessageType.
 * @param body del mensaje SSAP en formato NSDictionary.
 * @return La instancia del objeto inicializado.
 */
-(id)initWithMessageId:(NSString *)messageId sessionKey:(NSString *)sessionKey ontology:(NSString *)ontology direction:(SSAPMessageDirection)direction messageType:(SSAPMessageType)messageType body:(NSDictionary *)body;

/**
 * Convierte el objeto SSAPMessage en un NSString que representa el JSON en formato SSAP.
 *
 * @return el JSON en formato NSString.
 */
-(NSString *)getObjectInStringFormat;

@end
