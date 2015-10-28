//
//  Sofia2iOS.m
//  Sofia2iOS
//
//  Created by Adrián on 21/11/14.
//  Copyright (c) 2014 Indra. All rights reserved.
//

#import "Sofia2iOS.h"
#import "SRWebSocket.h"
#import <Foundation/NSJSONSerialization.h>
#import "SSAPMessage.h"

#define sofiaSocketEndPoint @"ws://sofia2.com/sib/api_websocket"

#define QueryTypeNATIVE @"NATIVE"
#define QueryTypeSQL @"SQLLIKE"
#define QueryTypeSIBDEFINED @"SIB_DEFINED"
#define QueryTypeCEP @"CEP"
#define QueryTypeBDH @"BDH"


@interface Sofia2iOS () <SRWebSocketDelegate>

@property (nonatomic, strong) SuccessHandler successHandler;
@property (nonatomic, strong) ErrorHandler errorHandler;

@end

@implementation Sofia2iOS {

    SRWebSocket *_webSocket;
    
}

BOOL joinToSofia;
BOOL connected;
static Sofia2iOS *instance;


+ (Sofia2iOS *)sharedInstance {

	if(!instance) {
        instance= [[Sofia2iOS alloc] init];
        connected = NO;
        joinToSofia = NO;
    }
    return instance;
}

- (void)connectWithSuccessHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    
    [self setSuccessHandler:handler];
    [self setErrorHandler:errorHandler];
    
    //Si el socket está abierto, primero se cierra
    _webSocket.delegate = nil;
    [_webSocket close];
    
    //El socket se inicializa con el end point adecuado
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:sofiaSocketEndPoint]]];
    _webSocket.delegate = self;
    
    //Se abre el canal de comunicación
    NSLog(@"Opening Connection...");
    [_webSocket open];
}

- (BOOL)isConnected {
    return connected;
}


- (void)sendJOINMessageWithToken:(NSString *)token instance:(NSString *)instance sessionKey:(NSString *)sessionKey successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    
    [self setSuccessHandler:handler];
	[self setErrorHandler:errorHandler];
    
    //Se crea el mensaje adecuado para la operación solicitada
    SSAPMessage *messageObject = [[SSAPMessage alloc] initWithMessageId:nil sessionKey:sessionKey ontology:nil direction:REQUEST messageType:JOIN body:@{@"token": token, @"instance": instance}];
    
    [self sendMessageToSofia:[messageObject getObjectInStringFormat]];
}


- (void)sendLEAVEMessageWithSessionKey:(NSString *)sessionKey successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    
    [self setSuccessHandler:handler];
    [self setErrorHandler:errorHandler];
    
    SSAPMessage *messageObject = [[SSAPMessage alloc] initWithMessageId:nil sessionKey:sessionKey ontology:nil direction:REQUEST messageType:LEAVE body:nil];
    
    //Al hacer cualquiera de las operaciones menos JOIN, hay que comprobar que el KP esta conectado con Sofia, ya que si se ejecuta sin estar conectado se produce un crash
    if(joinToSofia) {
        [self sendMessageToSofia:[messageObject getObjectInStringFormat]];
    }
    else {
        if(_errorHandler) {
            _errorHandler(nil);
        }
    }
}


- (void)sendQUERYMessageWithSessionKey:(NSString *)sessionKey query:(NSString *)query queryType:(NSInteger)queryType ontology:(NSString *)ontology successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    
    [self setSuccessHandler:handler];
    [self setErrorHandler:errorHandler];
    
    SSAPMessage *messageObject = [[SSAPMessage alloc] initWithMessageId:nil sessionKey:sessionKey ontology:ontology direction:REQUEST messageType:QUERY body:@{@"query": query, @"queryType": [self stringValueOfQueryType:queryType]}];
    
    //Al hacer cualquiera de las operaciones menos JOIN, hay que comprobar que el KP esta conectado con Sofia, ya que si se ejecuta sin estar conectado se produce un crash
    if(joinToSofia) {
        [self sendMessageToSofia:[messageObject getObjectInStringFormat]];
    }
    else {
        if(_errorHandler) {
            _errorHandler(nil);
        }
    }
}


- (void)sendINSERTMessageWithSessionKey:(NSString *)sessionKey query:(NSString *)query queryType:(NSInteger)queryType queryParams:(NSDictionary *)queryParams ontology:(NSString *)ontology successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    
    [self setSuccessHandler:handler];
    [self setErrorHandler:errorHandler];
    
    //Si no hay queryParams (casi siempre será así) le pasamos null en este campo, pero si sí que hay, le pasamos el diccionario con los parámetros
    SSAPMessage *messageObject;
    if(!queryParams) {
        messageObject = [[SSAPMessage alloc] initWithMessageId:nil sessionKey:sessionKey ontology:ontology direction:REQUEST messageType:INSERT body:@{@"query": query, @"queryType": [self stringValueOfQueryType:queryType], @"queryParams": [NSNull null]}];
    }
    else {
        messageObject = [[SSAPMessage alloc] initWithMessageId:nil sessionKey:sessionKey ontology:ontology direction:REQUEST messageType:INSERT body:@{@"query": query, @"queryType": [self stringValueOfQueryType:queryType], @"queryParams": queryParams}];
    }
    
    //Al hacer cualquiera de las operaciones menos JOIN, hay que comprobar que el KP esta conectado con Sofia, ya que si se ejecuta sin estar conectado se produce un crash
    if(joinToSofia) {
        [self sendMessageToSofia:[messageObject getObjectInStringFormat]];
    }
    else {
        if(_errorHandler) {
            _errorHandler(nil);
        }
    }
}


- (void)sendUPDATEMessageWithSessionKey:(NSString *)sessionKey query:(NSString *)query queryType:(NSInteger)queryType queryParams:(NSDictionary *)queryParams ontology:(NSString *)ontology successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    
    [self setSuccessHandler:handler];
    [self setErrorHandler:errorHandler];
    
    //Si no hay queryParams (casi siempre será así) le pasamos null en este campo, pero si sí que hay, le pasamos el diccionario con los parámetros
    SSAPMessage *messageObject;
    if(!queryParams) {
        messageObject = [[SSAPMessage alloc] initWithMessageId:nil sessionKey:sessionKey ontology:ontology direction:REQUEST messageType:UPDATE body:@{@"query": query, @"queryType": [self stringValueOfQueryType:queryType], @"queryParams": [NSNull null]}];
    }
    else {
        messageObject = [[SSAPMessage alloc] initWithMessageId:nil sessionKey:sessionKey ontology:ontology direction:REQUEST messageType:UPDATE body:@{@"query": query, @"queryType": [self stringValueOfQueryType:queryType], @"queryParams": queryParams}];
    }
    
    //Al hacer cualquiera de las operaciones menos JOIN, hay que comprobar que el KP esta conectado con Sofia, ya que si se ejecuta sin estar conectado se produce un crash
    if(joinToSofia) {
        [self sendMessageToSofia:[messageObject getObjectInStringFormat]];
    }
    else {
        if(_errorHandler) {
            _errorHandler(nil);
        }
    }
}


- (void)sendSUBSCRIBEMessageWithSessionKey:(NSString *)sessionKey query:(NSString *)query queryType:(NSInteger)queryType msRefresh:(NSInteger)msRefresh ontology:(NSString *)ontology messageId:(NSString *)messageId successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    
    [self setSuccessHandler:handler];
    [self setErrorHandler:errorHandler];
    
    SSAPMessage *messageObject = [[SSAPMessage alloc] initWithMessageId:messageId sessionKey:sessionKey ontology:ontology direction:REQUEST messageType:SUBSCRIBE body:@{@"msRefresh": [NSNumber numberWithInt:msRefresh], @"query": query, @"queryType": [self stringValueOfQueryType:queryType]}];
    
    //Al hacer cualquiera de las operaciones menos JOIN, hay que comprobar que el KP esta conectado con Sofia, ya que si se ejecuta sin estar conectado se produce un crash
    if(joinToSofia) {
        [self sendMessageToSofia:[messageObject getObjectInStringFormat]];
    }
    else {
        if(_errorHandler) {
            _errorHandler(nil);
        }
    }
}


- (void)sendUNSUBSCRIBEMessageWithSessionKey:(NSString *)sessionKey idSuscripcion:(NSString *)idSuscripcion ontology:(NSString *)ontology successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler {
    
    [self setSuccessHandler:handler];
    [self setErrorHandler:errorHandler];
    
    SSAPMessage *messageObject = [[SSAPMessage alloc] initWithMessageId:nil sessionKey:sessionKey ontology:ontology direction:REQUEST messageType:UNSUBSCRIBE body:@{@"idSuscripcion": idSuscripcion}];
    
    //Al hacer cualquiera de las operaciones menos JOIN, hay que comprobar que el KP esta conectado con Sofia, ya que si se ejecuta sin estar conectado se produce un crash
    if(joinToSofia) {
        [self sendMessageToSofia:[messageObject getObjectInStringFormat]];
    }
    else {
        if(_errorHandler) {
            _errorHandler(nil);
        }
    }
}


/**
 * Retorna el valor en formato NSString del tipo de query que se le pasa como parámetro.
 */
- (NSString *)stringValueOfQueryType:(NSInteger)queryType {
    
    //Dependiendo del valor de queryType, el tipo de query sera uno u otro
    NSString *queryTypeString = [[NSString alloc] init];
    switch (queryType) {
        case 0:
            queryTypeString = QueryTypeSQL;
            break;
        case 1:
            queryTypeString = QueryTypeNATIVE;
            break;
        case 2:
            queryTypeString = QueryTypeSIBDEFINED;
            break;
        case 3:
            queryTypeString = QueryTypeCEP;
            break;
        case 4:
            queryTypeString = QueryTypeBDH;
            break;
        default:
            queryTypeString = QueryTypeSQL;
            break;
    }
    return queryTypeString;
}


/**
 * Envía un mensaje desde el KP a sofia a través del socket.
 */
- (void)sendMessageToSofia:(NSString *)message
{
    if(connected) {
        [_webSocket send:message];
        NSLog(@"Sending message \"%@\"", message);
    }
    else {
        //Al haberse producido un error en la comunicación con sofia, en el KP se tiene que ejecutar el bloque correspondiente con la petición errónea. Le enviamos nil al KP, ya que no es un error que retorne sofia
        if(_errorHandler) {
            _errorHandler(nil);
        }
    }
}


//Métodos que implementan el delegado de SocketRocket
#pragma mark - SRWebSocketDelegate

/**
 * Se ejecuta cuando se ha abierto un socket correctamente entre un KP y sofia.
 */
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    connected = YES;
    
    //Al ser exitosa la comunicación entre el KP y sofia, se tiene que ejecutar el bloque correspondiente con la petición exitosa. Le enviamos nil al KP, ya que no se ha recibido ninguna respuesta de sofia
    if(_successHandler) {
        _successHandler(nil);
    }
}

/**
 * Se ejecuta cuando ha ocurrido un error (casi siempre debido a la conexión a la red) en el canal de comunicación entre el KP y sofia.
 */
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@"Websocket Failed With Error %@", error);
    _webSocket = nil;
    
    //Al haberse producido un error en la comunicación con sofia, en el KP se tiene que ejecutar el bloque correspondiente con la petición errónea. Le enviamos nil al KP, ya que no es un error que retorne sofia
    if(_errorHandler) {
		_errorHandler(nil);
	}
}

/**
 * Se ejecuta cuando un KP recibe información de sofia a través del socket.
 */
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"Received \"%@\"", message);
    
    NSData *data = [(NSString *)message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if([[json objectForKey:kDirection] isEqualToString:@"ERROR"]) {
        //Al haberse producido un error en los datos enviados a sofia, en el KP se tiene que ejecutar el bloque correspondiente con la petición errónea. pasándole al KP los datos devueltos por sofia
        if(_errorHandler) {
            _errorHandler(json);
        }
    }
    else {
        //Cuando la operacion JOIN se ejecuta correctamente, el resto de operaciones pueden lanzarse
        if([[json objectForKey:kDirection] isEqualToString:@"RESPONSE"] && [[json objectForKey:kMessageType] isEqualToString:@"JOIN"]) {
            
            joinToSofia = YES;
        }
        //Cuando la operacion LEAVE se ejecuta correctamente, no se pueden lanzar el resto de operaciones (solo la operacion JOIN)
        else if([[json objectForKey:kDirection] isEqualToString:@"RESPONSE"] && [[json objectForKey:kMessageType] isEqualToString:@"LEAVE"]) {
            
            joinToSofia = NO;
        }
        //Al ser exitosa la comunicación entre el KP y sofia, se tiene que ejecutar el bloque correspondiente con la petición exitosa, pasándole al KP los datos devueltos por sofia
        if(_successHandler) {
            _successHandler(json);
        }
    }
}

/**
 * Se ejecuta cuando se ha cerrado el socket entre un KP y sofia.
 */
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
{
    NSLog(@"WebSocket closed");
    _webSocket = nil;
    connected = NO;
    joinToSofia = NO;
}


@end
