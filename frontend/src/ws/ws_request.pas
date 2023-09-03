unit ws_request;


interface
uses   REST.Authenticator.Basic,Rest.Client,JSON,rest.Types,system.SysUtils;
function GetJson(p_endpoint:string;p_body:unicodestring;p_method:TRestRequestMethod; out p_response:unicodestring):boolean;

Const
 cBase_URL ='https://192.168.1.57:2112/demo';
implementation
uses fmx.Dialogs;

function GetJson(p_endpoint:string;p_body:unicodestring;p_method:TRestRequestMethod; out p_response:unicodestring):Boolean;
var
  RESTClient: TRESTClient;
  RESTRequest:TRESTRequest;
  RESTResponse: TRESTResponse;
  R1:TRestRequestParameter;

  vOK:boolean;
begin

  //Create the Rest client and bind with the basic auth component
  RESTClient              :=TRestCLient.Create(nil);
  RESTClient.BaseURL      := cBase_url;
  RESTClient.ContentType  :='application/json';
  RESTClient.RaiseExceptionOn500:=False;

  //Create the Rest request and bind with the client component
  RestRequest:=TRESTRequest.Create(nil);
  RestRequest.Client:=RESTClient;
  RestRequest.Method:=p_method;
  RestRequest.Resource:=p_endpoint;

  R1:=RestRequest.Params.AddItem;
  R1.Name:='P0';
  R1.Value:=p_body;
  R1.Kind:=pkRequestBody;
  R1.ContentTypeStr:='application/json';

  //Create the Response component.
  RestResponse:=TRESTResponse.Create(nil);
  RestResponse.ContentType:='application/json';
  //bind the request with the response component.
  RestRequest.Response:=RESTResponse;
  try

   try
    RestRequest.Execute; //Call the webservice
   except
    // log.d
  end;

  vOK:= RestResponse.StatusCode in [200..255];
  p_response:=RESTResponse.Content;

  finally
    result:=vOK;
    RESTClient.Free;
    RestResponse.Free;
    RestRequest.Free;
  end;

end;


end.
