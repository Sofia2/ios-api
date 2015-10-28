//
//  ViewController.m
//  Sofia2iOSExample
//
//  Created by Adrián on 21/11/14.
//  Copyright (c) 2014 Indra. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Sofia2iOS.h"

#define kBody @"body"
#define kDirection @"direction"
#define kMessageId @"messageId"
#define kMessageType @"messageType"
#define kOntology @"ontology"
#define kSessionKey @"sessionKey"

#define kData @"data"
#define kError @"error"
#define kErrorCode @"errorCode"
#define kOk @"ok"


@interface ViewController ()

@property (nonatomic,strong) NSArray *pickerData;
@property (nonatomic,strong) UIButton* buttonSelected;

//En este objeto se introduce la sessionKey que nos devuelve sofia cuando hacemos la operacion JOIN
@property (nonatomic, strong) NSString* sessionKey;

//En este objeto se introduce el idSuscripcion que nos devuelve sofia cuando hacemos la operacion SUBSCRIBE
@property (nonatomic, strong) NSString* idSuscripcion;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.pickerData = [[NSArray alloc] initWithObjects:@"SQL-LIKE", @"NATIVE", nil];
    self.buttonSelected = nil;
    
    self.sessionKey = nil;
    self.idSuscripcion = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[self.queryTextField layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.queryTextField layer] setBorderWidth:2.3];
    [[self.queryTextField layer] setCornerRadius:15];
    
    [[self.insertTextField layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.insertTextField layer] setBorderWidth:2.3];
    [[self.insertTextField layer] setCornerRadius:15];
    
    [[self.updateTextField layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.updateTextField layer] setBorderWidth:2.3];
    [[self.updateTextField layer] setCornerRadius:15];
    
    [[self.subscribeTextField layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.subscribeTextField layer] setBorderWidth:2.3];
    [[self.subscribeTextField layer] setCornerRadius:15];
    
    [[self.responseTextField layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[self.responseTextField layer] setBorderWidth:2.3];
    [[self.responseTextField layer] setCornerRadius:15];
    
    [self.view setAlpha:0.5];
    [self.view setUserInteractionEnabled:NO];
    
    //Si el socket entre el KP y sofia no esta abierto, habra que establecer la conexion
    if(![[Sofia2iOS sharedInstance] isConnected]) {
    
        [[Sofia2iOS sharedInstance] connectWithSuccessHandler:^(NSDictionary *responseDict) {
            
            //Una vez se establece la conexion, ya se puede realizar la comunicacion bidireccional entre el KP y Sofia
            [self.view setAlpha:1.0];
            [self.view setUserInteractionEnabled:YES];
            
            //Ejemplo de operacion QUERY
            [self.KPTextField setText:@"SensorHumedadKP:SensorHumedadKPInstance01"];
            [self.ontologyTextField setText:@"SensorHumedad"];
            [self.tokenTextField setText:@"87d95afa2e87456e96a822e49495d1d1"];
            [self.queryTextField setText:@"select * from SensorHumedad  order by 'contextData.timestamp'"];
            
            //Ejemplo de operacion INSERT
            [self.insertTextField setText:@"insert into SensorHumedad(identificador,medida,unidad,timestamp) values ('ST-TA3231-1HH',55,'C',\"{ '$date': '2014-04-29T08:24:54.005Z'}\")"];
            
            //Ejemplo de operacion UPDATE
            [self.updateTextField setText:@"update SensorHumedad set SensorHumedad.medida = 52 where SensorHumedad.identificador = 'ST-TA3231-1HH'"];
            
            //Ejemplo de operacion SUBSCRIBE
            [self.subscribeTextField setText:@""];

        } errorHandler:^(NSDictionary *error) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Error al abrir el socket entre el KP y Sofia" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }];
    }
    else {
        [self.view setAlpha:1.0];
        [self.view setUserInteractionEnabled:YES];
        
        //Ejemplo de operacion QUERY
        [self.KPTextField setText:@"SensorHumedadKP:SensorHumedadKPInstance01"];
        [self.ontologyTextField setText:@"SensorHumedad"];
        [self.tokenTextField setText:@"87d95afa2e87456e96a822e49495d1d1"];
        [self.queryTextField setText:@"select * from SensorHumedad  order by 'contextData.timestamp'"];
        
        //Ejemplo de operacion INSERT
        [self.insertTextField setText:@"{insert into SensorHumedad(identificador,medida,unidad,timestamp) values ('ST-TA3231-1HH',50,'C',\"{ '$date': '2014-04-29T08:24:54.005Z'}\")}"];
        
        //Ejemplo de operacion UPDATE
        [self.updateTextField setText:@"{update SensorHumedad set SensorHumedad.medida = 52 where SensorHumedad.identificador = 'ST-TA3231-1HH'}"];
        
        //Ejemplo de operacion SUBSCRIBE
        [self.subscribeTextField setText:@""];
    }
    
}


- (IBAction)queryTypeButtonSelected:(UIButton *)sender {
    
    self.buttonSelected = sender;
    [UIView animateWithDuration:0.5 animations:^{
        [self.pickerView setFrame:CGRectMake(0, 869, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
        [self.pickerView setHidden:NO];
    }];
}


- (IBAction)insertTypeButtonSelected:(UIButton *)sender {
    self.buttonSelected = sender;
    [UIView animateWithDuration:0.5 animations:^{
        [self.pickerView setFrame:CGRectMake(0, 869, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
        [self.pickerView setHidden:NO];
    }];
}

- (IBAction)updateTypeButtonSelected:(UIButton *)sender {
    self.buttonSelected = sender;
    [UIView animateWithDuration:0.5 animations:^{
        [self.pickerView setFrame:CGRectMake(0, 869, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
        [self.pickerView setHidden:NO];
    }];
}


- (IBAction)subscribeTypeButtonSelected:(UIButton *)sender {
    self.buttonSelected = sender;
    [UIView animateWithDuration:0.5 animations:^{
        [self.pickerView setFrame:CGRectMake(0, 869, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
        [self.pickerView setHidden:NO];
    }];
}


- (IBAction)joinButtonPressed:(UIButton *)sender {
    
    [self.view setAlpha:0.5];
    [self.view setUserInteractionEnabled:NO];
    
    self.sessionKey = nil;
    
    //Enviamos un mensaje JOIN a Sofia, para ello le pasamos el token del KP, la instancia del KP y la clave de la sesion en el caso de que queramos restablecer una sesion.
    [[Sofia2iOS sharedInstance] sendJOINMessageWithToken:self.tokenTextField.text instance:self.KPTextField.text sessionKey:self.sessionKey successHandler:^(NSDictionary *responseDict) {
        
        //Si hemos recibido respuesta satisfactoria de Sofia, guardamos la sessionKey que nos devuelve, ya que habrá que utilizarla en las demás operaciones
        self.sessionKey = [responseDict objectForKey:kSessionKey];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseDict options:0 error:&error];
        if (!jsonData) {
            NSLog(@"Error: %@", error);
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [self.responseTextField setText:jsonString];
        }
        [self.view setAlpha:1.0];
        [self.view setUserInteractionEnabled:YES];
        
    } errorHandler:^(NSDictionary *error) {
        
        //Si hay un error al enviar la operación a Sofia, mandamos la información de dicho error a la funcion manejadora de errores
        [self handleErrorWithInfo:error];
        [self.view setAlpha:1.0];
        [self.view setUserInteractionEnabled:YES];
        
    }];
    
}

- (IBAction)reJoinButtonPressed:(UIButton *)sender {
    
    [self.view setAlpha:0.5];
    [self.view setUserInteractionEnabled:NO];
    
    [[Sofia2iOS sharedInstance] sendJOINMessageWithToken:self.tokenTextField.text instance:self.KPTextField.text sessionKey:self.sessionKey successHandler:^(NSDictionary *responseDict) {
        
        self.sessionKey = [responseDict objectForKey:kSessionKey];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseDict options:0 error:&error];
        if (!jsonData) {
            NSLog(@"Error: %@", error);
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [self.responseTextField setText:jsonString];
        }
        [self.view setAlpha:1.0];
        [self.view setUserInteractionEnabled:YES];
        
    } errorHandler:^(NSDictionary *error) {
        
        [self handleErrorWithInfo:error];
        [self.view setAlpha:1.0];
        [self.view setUserInteractionEnabled:YES];
        
    }];
    
}

- (IBAction)leaveButtonPressed:(UIButton *)sender {
    
    [self.view setAlpha:0.5];
    [self.view setUserInteractionEnabled:NO];
    
    //Enviamos un mensaje LEAVE a Sofia, para ello le pasamos la clave de la sesion que queremos cerrar.
    [[Sofia2iOS sharedInstance] sendLEAVEMessageWithSessionKey:self.sessionKey successHandler:^(NSDictionary *responseDict) {
        
        //Como la sesion se ha cerrado correctamente, eliminamos la clave de dicha sesion localmente
        self.sessionKey = nil;
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseDict options:0 error:&error];
        if (!jsonData) {
            NSLog(@"Error: %@", error);
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [self.responseTextField setText:jsonString];
        }
        [self.view setAlpha:1.0];
        [self.view setUserInteractionEnabled:YES];
        
    } errorHandler:^(NSDictionary *error) {
        
        [self handleErrorWithInfo:error];
        [self.view setAlpha:1.0];
        [self.view setUserInteractionEnabled:YES];
        
    }];
    
}

- (IBAction)queryButtonPressed:(UIButton *)sender {
    
    [self.view setAlpha:0.5];
    [self.view setUserInteractionEnabled:NO];
    
    NSInteger queryType;
    if([self.queryTypeButton.titleLabel.text isEqualToString:@"NATIVE"]) {
        queryType = 1;
    }
    else {
        queryType = 0;
    }
    
    //Enviamos un mensaje QUERY a Sofia, para ello le pasamos la clave de la sesion, la query que queremos hacer sobre Sofia, el tipo de query, que tendrá que corresponder con el lenguaje utilizado para escribir la query, y la ontología de Sofia sobre la que queremos hacer la consulta.
    [[Sofia2iOS sharedInstance] sendQUERYMessageWithSessionKey:self.sessionKey query:self.queryTextField.text queryType:queryType ontology:self.ontologyTextField.text successHandler:^(NSDictionary *responseDict)
    {
        //En cada operación que hagamos se renueva la clave de la sesión, por lo que hay que guradarla después de cada operación satisfactoria
        self.sessionKey = [responseDict objectForKey:kSessionKey];
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseDict options:0 error:&error];
        if (!jsonData) {
            NSLog(@"Error: %@", error);
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [self.responseTextField setText:jsonString];
        }
        [self.view setAlpha:1.0];
        [self.view setUserInteractionEnabled:YES];
        
    } errorHandler:^(NSDictionary *error) {
        
        [self handleErrorWithInfo:error];
        [self.view setAlpha:1.0];
        [self.view setUserInteractionEnabled:YES];
        
    }];
    
}

- (IBAction)subscribeButtonPressed:(UIButton *)sender {
    
    [self.view setAlpha:0.5];
    [self.view setUserInteractionEnabled:NO];
    
    NSInteger queryType;
    if([self.subscribeTypeButton.titleLabel.text isEqualToString:@"NATIVE"]) {
        queryType = 1;
    }
    else {
        queryType = 0;
    }
    
    //Enviamos un mensaje SUBSCRIBE a Sofia, para ello le pasamos la clave de la sesion, la query que queremos hacer sobre Sofia, el tipo de query, que tendrá que corresponder con el lenguaje utilizado para escribir la query, el tiempo de refresco en milisegundos, la ontología de Sofia sobre la que queremos hacer la consulta, y el id del mensaje.
    [[Sofia2iOS sharedInstance] sendSUBSCRIBEMessageWithSessionKey:self.sessionKey query:self.subscribeTextField.text queryType:queryType msRefresh:1000 ontology:self.ontologyTextField.text messageId:nil successHandler:^(NSDictionary *responseDict)
     {
         self.sessionKey = [responseDict objectForKey:kSessionKey];
         
         //Si la operación es correcta, Sofia nos devuelve un identificador de la suscripcion para que el KP pueda interactuar con ella
         self.idSuscripcion = [[responseDict objectForKey:kBody] objectForKey:@"data"];
         
         NSError *error;
         NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseDict options:0 error:&error];
         if (!jsonData) {
             NSLog(@"Error: %@", error);
         } else {
             NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
             [self.responseTextField setText:jsonString];
         }
         [self.view setAlpha:1.0];
         [self.view setUserInteractionEnabled:YES];
         
     } errorHandler:^(NSDictionary *error) {
         
         [self handleErrorWithInfo:error];
         [self.view setAlpha:1.0];
         [self.view setUserInteractionEnabled:YES];
         
     }];
    
}


- (IBAction)unsubscribeButtonPressed:(UIButton *)sender {
    
    [self.view setAlpha:0.5];
    [self.view setUserInteractionEnabled:NO];
    
    //Enviamos un mensaje UNSUBSCRIBE a Sofia, para ello le pasamos la clave de la sesion, el identificador de la suscripcion (que nos devolvió la operación SUBSCRIBE) de la que queremos darnos de baja, y la ontología de Sofia sobre la que queremos hacer la consulta.
    [[Sofia2iOS sharedInstance] sendUNSUBSCRIBEMessageWithSessionKey:self.sessionKey idSuscripcion:self.idSuscripcion ontology:self.ontologyTextField.text successHandler:^(NSDictionary *responseDict)
     {
         self.sessionKey = [responseDict objectForKey:kSessionKey];
         
         //Como la suscripcion se ha dado de baja correctamente, eliminamos el identificador que almacenamos localmente
         self.idSuscripcion = nil;
         
         NSError *error;
         NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseDict options:0 error:&error];
         if (!jsonData) {
             NSLog(@"Error: %@", error);
         } else {
             NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
             [self.responseTextField setText:jsonString];
         }
         [self.view setAlpha:1.0];
         [self.view setUserInteractionEnabled:YES];
         
     } errorHandler:^(NSDictionary *error) {
         
         [self handleErrorWithInfo:error];
         [self.view setAlpha:1.0];
         [self.view setUserInteractionEnabled:YES];
         
     }];
    
}


- (IBAction)clearButtonPressed:(UIButton *)sender {
    
    [self.responseTextField setText:@""];
    
}

- (IBAction)reConnectButtonPressed:(UIButton *)sender {
    
    [self.view setAlpha:0.5];
    [self.view setUserInteractionEnabled:NO];
    
    //Si el socket se ha cerrado por alguna cuestión, podremos volver a abrirlo en cualquier momento
    if(![[Sofia2iOS sharedInstance] isConnected]) {
        
        [[Sofia2iOS sharedInstance] connectWithSuccessHandler:^(NSDictionary *responseDict) {
            
            [self.view setAlpha:1.0];
            [self.view setUserInteractionEnabled:YES];
            
        } errorHandler:^(NSDictionary *error) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Error al abrir el socket entre el KP y Sofia" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
        }];
    }
    else {
        [self.view setAlpha:1.0];
        [self.view setUserInteractionEnabled:YES];
    }
    
}

- (IBAction)insertButtonPressed:(UIButton *)sender {
    
    [self.view setAlpha:0.5];
    [self.view setUserInteractionEnabled:NO];
    
    NSInteger queryType;
    if([self.insertTypeButton.titleLabel.text isEqualToString:@"NATIVE"]) {
        queryType = 1;
    }
    else {
        queryType = 0;
    }
    
    //Enviamos un mensaje INSERT a Sofia, para ello le pasamos la clave de la sesion, la query que queremos hacer sobre Sofia (tiene que ser de tipo insert), el tipo de query, que tendrá que corresponder con el lenguaje utilizado para escribir la query, los parametros de la query (no se utiliza para querys SQL ni para querys MongoDB(NATIVE)), y la ontología de Sofia sobre la que queremos hacer la consulta.
    [[Sofia2iOS sharedInstance] sendINSERTMessageWithSessionKey:self.sessionKey query:self.insertTextField.text queryType:queryType queryParams:nil ontology:self.ontologyTextField.text successHandler:^(NSDictionary *responseDict)
     {
         self.sessionKey = [responseDict objectForKey:kSessionKey];
         
         NSError *error;
         NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseDict options:0 error:&error];
         if (!jsonData) {
             NSLog(@"Error: %@", error);
         } else {
             NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
             [self.responseTextField setText:jsonString];
         }
         [self.view setAlpha:1.0];
         [self.view setUserInteractionEnabled:YES];
         
     } errorHandler:^(NSDictionary *error) {
         
         [self handleErrorWithInfo:error];
         [self.view setAlpha:1.0];
         [self.view setUserInteractionEnabled:YES];
         
     }];
    
}

- (IBAction)updateButtonPressed:(UIButton *)sender {
    
    [self.view setAlpha:0.5];
    [self.view setUserInteractionEnabled:NO];
    
    NSInteger queryType;
    if([self.updateTypeButton.titleLabel.text isEqualToString:@"NATIVE"]) {
        queryType = 1;
    }
    else {
        queryType = 0;
    }
    
    //Enviamos un mensaje UPDATE a Sofia, para ello le pasamos la clave de la sesion, la query que queremos hacer sobre Sofia (tiene que ser de tipo update), el tipo de query, que tendrá que corresponder con el lenguaje utilizado para escribir la query, los parametros de la query (no se utiliza para querys SQL ni para querys MongoDB(NATIVE)), y la ontología de Sofia sobre la que queremos hacer la consulta.
    [[Sofia2iOS sharedInstance] sendUPDATEMessageWithSessionKey:self.sessionKey query:self.updateTextField.text queryType:queryType queryParams:nil ontology:self.ontologyTextField.text successHandler:^(NSDictionary *responseDict)
     {
         self.sessionKey = [responseDict objectForKey:kSessionKey];
         
         NSError *error;
         NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseDict options:0 error:&error];
         if (!jsonData) {
             NSLog(@"Error: %@", error);
         } else {
             NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
             [self.responseTextField setText:jsonString];
         }
         [self.view setAlpha:1.0];
         [self.view setUserInteractionEnabled:YES];
         
     } errorHandler:^(NSDictionary *error) {
         
         [self handleErrorWithInfo:error];
         [self.view setAlpha:1.0];
         [self.view setUserInteractionEnabled:YES];
         
     }];
    
}



#pragma mark - UIPickerViewDelegate

- (int)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (int)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerData.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.pickerData[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(self.buttonSelected == self.queryTypeButton) {
        [self.queryTypeButton setTitle:self.pickerData[row] forState:UIControlStateNormal];
        if([self.pickerData[row] isEqualToString:@"NATIVE"]) {
            [self.queryTextField setText:@"db.SensorHumedad.find().limit(10)"];
        }
        else {
            [self.queryTextField setText:@"select * from SensorHumedad  order by 'contextData.timestamp'"];
        }
    }
    else if(self.buttonSelected == self.insertTypeButton) {
        [self.insertTypeButton setTitle:self.pickerData[row] forState:UIControlStateNormal];
        if([self.pickerData[row] isEqualToString:@"NATIVE"]) {
            [self.insertTextField setText:@"'SensorHumedad':{'identificador':'ST-TA3231-1HH','medida':28,'unidad':'C','timestamp':{'$date':'2014-01-30T17:14:00Z'}}"];
        }
        else {
            [self.insertTextField setText:@"insert into SensorHumedad(identificador,medida,unidad,timestamp) values ('ST-TA3231-1HH',50,'C',\"{'$date':'2014-04-29T08:24:54.005Z'}\")"];
        }
    }
    else if(self.buttonSelected == self.updateTypeButton) {
        [self.updateTypeButton setTitle:self.pickerData[row] forState:UIControlStateNormal];
        if([self.pickerData[row] isEqualToString:@"NATIVE"]) {
            [self.updateTextField setText:@"db.SensorHumedad.update({'SensorHumedad.identificador':{$eq:'ST-TA3231-1HH'}},{'SensorHumedad.medida':{$set:{50}}})"];
        }
        else {
            [self.updateTextField setText:@"update SensorHumedad set SensorHumedad.medida=52 where SensorHumedad.identificador='ST-TA3231-1HH'"];
        }
    }
    else if(self.buttonSelected == self.subscribeTypeButton) {
        [self.subscribeTypeButton setTitle:self.pickerData[row] forState:UIControlStateNormal];
        if([self.pickerData[row] isEqualToString:@"NATIVE"]) {
            [self.subscribeTextField setText:@"{SensorHumedad.medida:{$gt:1}}"];
        }
        else {
            [self.subscribeTextField setText:@""];
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.pickerView setFrame:CGRectMake(0, 1024, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
        [self.pickerView setHidden:YES];
    }];
    
    self.buttonSelected = nil;
}


/**
 * Maneja los errores que se producen en la ejecución de las operaciones.
 */
- (void)handleErrorWithInfo:(NSDictionary *)error {
    //Si se ha producido un error al ejecutar una operación, el API nos retornará información acerca del error. Puede haber 2 tipos:
    //-Error en el canal de comunicación(socket): el diccionario del error vendrá a nil y habrá que mostrar un mensaje genérico de error (Error de conexión).
    //-Error devuelto por Sofia: si se ha enviado algún dato erróneo o no existe la información que solicitamos, nos devuelve un diccionario con información sobre el error.
    if(error) {
        NSError *err;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:error options:0 error:&err];
        if (!jsonData) {
            NSLog(@"Error: %@", err);
        } else {
            NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [self.responseTextField setText:jsonString];
            
            NSString *title = [[error objectForKey:kBody] objectForKey:kErrorCode] != [NSNull null] ? [[error objectForKey:kBody] objectForKey:kErrorCode] : @"";
            NSString *messg = [[error objectForKey:kBody] objectForKey:kError] != [NSNull null] ? [[error objectForKey:kBody] objectForKey:kError] : @"";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:messg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    else {
        [self.responseTextField setText:@"Connection error"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection error" message:@"Error en el canal de comunicacion entre el KP y Sofia" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}


@end
