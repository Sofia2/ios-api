//
//  Sofia2iOS.h
//  Sofia2iOS
//
//  Created by Adrián on 21/11/14.
//  Copyright (c) 2014 Indra. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^SuccessHandler)(NSDictionary *responseDict);
typedef void (^ErrorHandler)(NSDictionary *error);

@interface Sofia2iOS : NSObject

/**
 * Implementación del patrón singleton para la clase Sofia2iOS.
 *
 * @return la instancia de Sofia2iOS.
 */
+ (Sofia2iOS *)sharedInstance;

/**
 * Determina si hay un socket abierto entre el dispositivo(KP) y Sofia.
 *
 * @return booleano que indica si hay conexión o no.
 */
- (BOOL)isConnected;

/**
 * Establece una conexión entre el dispositivo(KP) y Sofia.
 *
 * @param handler bloque que se llamará cuando la conexión sea exitosa.
 * @param errorHandler bloque que se llamará cuando la conexión sea errónea.
 */
- (void)connectWithSuccessHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

/**
 * Envía un mensaje JOIN a Sofia, tanto el de solicitud de inicio de sesión como el de renovación de sesión (el sessionKey no será nil).
 *
 * @param token del mensaje SSAP.
 * @param instance del mensaje SSAP.
 * @param sessionKey del mensaje SSAP.
 * @param handler bloque que se llamará cuando la petición sea exitosa.
 * @param errorHandler bloque que se llamará cuando la petición sea errónea.
 */
- (void)sendJOINMessageWithToken:(NSString *)token instance:(NSString *)instance sessionKey:(NSString *)sessionKey successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

/**
 * Envía un mensaje LEAVE a Sofia.
 *
 * @param sessionKey del mensaje SSAP.
 * @param handler bloque que se llamará cuando la petición sea exitosa.
 * @param errorHandler bloque que se llamará cuando la petición sea errónea.
 */
- (void)sendLEAVEMessageWithSessionKey:(NSString *)sessionKey successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

/**
 * Envía un mensaje QUERY a Sofia.
 *
 * @param sessionKey del mensaje SSAP.
 * @param query que representa la petición que se desea realizar a Sofia.
 * @param queryType tipo de query que se desea realizar: 0 -> SQL, 1 -> MongoDB(NATIVE), 2 -> SIB-DEFINED, 3 -> CEP(no aplica para esta operación), 4 -> BDH
 * @param ontology del mensaje SSAP.
 * @param handler bloque que se llamará cuando la petición sea exitosa.
 * @param errorHandler bloque que se llamará cuando la petición sea errónea.
 */
- (void)sendQUERYMessageWithSessionKey:(NSString *)sessionKey query:(NSString *)query queryType:(NSInteger)queryType ontology:(NSString *)ontology successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

/**
 * Envía un mensaje INSERT a Sofia.
 *
 * @param sessionKey del mensaje SSAP.
 * @param query que representa la petición que se desea realizar a Sofia.
 * @param queryType tipo de query que se desea realizar: 0 -> SQL, 1 -> MongoDB(NATIVE), 2 -> SIB-DEFINED, 3 -> CEP(no aplica para esta operación), 4 -> BDH
 * @param queryParams parámetros que se pasan a la query (el valor es siempre nil para SQL y MongoDB).
 * @param ontology del mensaje SSAP.
 * @param handler bloque que se llamará cuando la petición sea exitosa.
 * @param errorHandler bloque que se llamará cuando la petición sea errónea.
 */
- (void)sendINSERTMessageWithSessionKey:(NSString *)sessionKey query:(NSString *)query queryType:(NSInteger)queryType queryParams:(NSDictionary *)queryParams ontology:(NSString *)ontology successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

/**
 * Envía un mensaje UPDATE a Sofia.
 *
 * @param sessionKey del mensaje SSAP.
 * @param query que representa la petición que se desea realizar a Sofia.
 * @param queryType tipo de query que se desea realizar: 0 -> SQL, 1 -> MongoDB(NATIVE), 2 -> SIB-DEFINED, 3 -> CEP(no aplica para esta operación), 4 -> BDH
 * @param queryParams parámetros que se pasan a la query (el valor es siempre nil para SQL y MongoDB).
 * @param ontology del mensaje SSAP.
 * @param handler bloque que se llamará cuando la petición sea exitosa.
 * @param errorHandler bloque que se llamará cuando la petición sea errónea.
 */
- (void)sendUPDATEMessageWithSessionKey:(NSString *)sessionKey query:(NSString *)query queryType:(NSInteger)queryType queryParams:(NSDictionary *)queryParams ontology:(NSString *)ontology successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

/**
 * Envía un mensaje SUBSCRIBE a Sofia.
 *
 * @param sessionKey del mensaje SSAP.
 * @param query que representa la petición que se desea realizar a Sofia.
 * @param queryType tipo de query que se desea realizar: 0 -> SQL, 1 -> MongoDB(NATIVE), 2 -> SIB-DEFINED, 3 -> CEP, 4 -> BDH(no aplica para esta operación)
 * @param msRefresh tiempo de refresco en milisegundos.
 * @param ontology del mensaje SSAP.
 * @param messageId del mensaje SSAP.
 * @param handler bloque que se llamará cuando la petición sea exitosa.
 * @param errorHandler bloque que se llamará cuando la petición sea errónea.
 */
- (void)sendSUBSCRIBEMessageWithSessionKey:(NSString *)sessionKey query:(NSString *)query queryType:(NSInteger)queryType msRefresh:(NSInteger)msRefresh ontology:(NSString *)ontology messageId:(NSString *)messageId successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

/**
 * Envía un mensaje UNSUBSCRIBE a Sofia.
 *
 * @param sessionKey del mensaje SSAP.
 * @param idSuscripcion identificador de la suscripcion que se quiere dar de baja.
 * @param ontology del mensaje SSAP.
 * @param handler bloque que se llamará cuando la petición sea exitosa.
 * @param errorHandler bloque que se llamará cuando la petición sea errónea.
 */
- (void)sendUNSUBSCRIBEMessageWithSessionKey:(NSString *)sessionKey idSuscripcion:(NSString *)idSuscripcion ontology:(NSString *)ontology successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;


@end
