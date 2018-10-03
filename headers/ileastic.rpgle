**FREE

/if defined (ILEASTIC)
/eof
/endif

/define ILEASTIC

///
// ILEastic - Microservices for ILE on IBM i
//
// It is a self contained web application server for the ILE environment on 
// IBM i running microservices.
// <p>
// ILEastic is a service program that provides a simple, blazing fast 
// programmable HTTP server for your application so you easy can plug your RPG 
// code into a services infrastructure or make simple web applications without 
// the need of any third party webserver products.
//
// @author Niels Liisberg
// @date 27.08.2018
// @project ILEastic
// @link https://github.com/sitemule/ILEastic Project page
///



///
// String
//
// This data structure holds a string with variable length.
///
dcl-ds il_varchar qualified template;
    length  int(10);
    string  pointer;
end-ds;

///
// Configuration
///
dcl-ds il_config qualified template;
    host    varchar(64);
    port    int(10);
    filler  char(4096);
end-ds;

///
// HTTP request
//
// This data structure contains the values of the incoming
// HTTP request. The values can be retrieve by using the
// il_getVarcharValue procedure or by using one of the 
// il_getRequest... procedures.
///
dcl-ds il_request qualified template;
    config         pointer;
    method         likeds(il_varchar);
    url            likeds(il_varchar);
    resource       likeds(il_varchar);
    queryString    likeds(il_varchar);
    protocol       likeds(il_varchar);
    headers        likeds(il_varchar);
    content        likeds(il_varchar);
    contentType    varchar(256);
    completeHeader likeds(il_varchar);
end-ds;

///
// HTTP response
//
// This data structure contains the details of the HTTP
// response which will be sent by one of the il_response...
// procedures.
///
dcl-ds il_response qualified template;
    config      pointer;
    status      int(5);
    statusText  varchar(256);
    contentType varchar(256);
    charset     varchar(32) ;
end-ds;

///
// Get string value
//
// Returns the value of a string data structure (il_varchar).
//
// @param String
// @return Value of the string data structure
///
dcl-pr il_getVarcharValue varchar(524284:4) ccsid(*utf8) rtnparm
                extproc(*CWIDEN:'lvpc2lvc');
    string likeds(il_varchar);    
end-pr;

///
// Get HTTP request method
//
// Returns the HTTP method from the request (like GET, POST, DELETE, ...).
//
// @param Request
// @return HTTP method
///
dcl-pr il_getRequestMethod  varchar(256:2) ccsid(*utf8) rtnparm
                extproc(*CWIDEN:'il_getRequestMethod');
    request likeds(il_request);    
end-pr;

///
// Get request URL
// 
// Returns the request URL consisting of the resource and the query string.
// http://localhost:8080/api/v1/iledocs/search?q=map&scope=full would return
// /api/v1/iledocs/search?q=map&scope=full .
// <br/><br/>
// Any fragment entered in the request URL is not part of the return value.
//
// @param Request
// @return URL
///
dcl-pr il_getRequestUrl  varchar(524284:4) ccsid(*utf8) rtnparm
                extproc(*CWIDEN:'il_getRequestUrl');
    request likeds(il_request);    
end-pr;

///
// Get request resource
//
// Return the full resources path excluding the query string and the fragment.
// http://localhost:8080/api/v1/iledocs/search?q=map&scope=full would return
// /api/v1/iledocs/search .
//
// @param Request
// @return Resource
///
dcl-pr il_getRequestResource  varchar(524284:4) ccsid(*utf8) rtnparm
                extproc(*CWIDEN:'il_getRequestResource');
    request likeds(il_request);    
end-pr;

///
// Get request query string
//
// Returns the request query string (without the starting ? separator). So for
// a request like http://localhost:8080/path?query=string you would get 
// query=string as the return value. The ? sign as a separator of the resource
// path and the query string is not part of the return value. If the URL does 
// not contain a query string a zero length string is returned.
//
// @param Request
// @return Query string
///
dcl-pr il_getRequestQueryString  varchar(524284:4) ccsid(*utf8) rtnparm
                extproc(*CWIDEN:'il_getRequestQueryString');
    request likeds(il_request);    
end-pr;

///
// Get request protocol
//
// Returns the request protocol, f. e. HTTP/1.1 .
//
// @param Request
// @return Protocol
///
dcl-pr il_getRequestProtocol  varchar(256:2)  ccsid(*utf8) rtnparm
                extproc(*CWIDEN:'il_getRequestProtocol');
    request likeds(il_request);    
end-pr;

///
// Get request headers
//
// Returns the request headers as they are in the HTTP message.
//
// @param Request
// @return HTTP headers
///
dcl-pr il_getRequestHeaders  varchar(524284:4)  ccsid(*utf8) rtnparm
                extproc(*CWIDEN:'il_getRequestHeaders');
    request likeds(il_request);    
end-pr;

///
// Get request header
//
// Returns a single request header.
//
// @param Request
// @return HTTP header
///
dcl-pr il_getRequestHeader  varchar(524284:4)  ccsid(*utf8) rtnparm
                extproc(*CWIDEN:'il_getRequestHeader');
    request  likeds(il_request); 
    header   pointer value options(*string);   
end-pr;

///
// Get request content
//
// Returns the body content of the HTTP message. If the content exceeds
// the length of the return value the subfield <em>content</em> of the 
// request data structure can be accessed directly to process the 
// content block by block, see il_request.content.
//
// @param Request
// @return HTTP message content
///
dcl-pr il_getContent  varchar(524284:4)  ccsid(*utf8) rtnparm
                extproc(*CWIDEN:'il_getContent');
    request likeds(il_request);    
end-pr;

///
// Get file MIME type
//
// If the requested resource is a file then the corresponding MIME type to
// the file will be returned.
//
// @param Request
// @return MIME type
///
dcl-pr il_getFileMimeType  varchar(256:2)  rtnparm
                extproc(*CWIDEN:'il_getFileMimeType');
    fileName    varchar(256:2);    
end-pr;

///
// Get file extension
// 
// If the requested resource is a file then the file extension will be returned.
// A request for http://localhost:8080/index.html will return html.
// 
// @param Request
// @return file extension
///
dcl-pr il_getFileExtension  varchar(256:2)  rtnparm
                extproc(*CWIDEN:'il_getFileExtension');
    fileName    varchar(256:2);    
end-pr;

///
// Start server
//
// Starts the server with the passed configuration and for the passed servlet.
//
// @param Configuration
// @param Servlet
///
dcl-pr il_listen extproc(*CWIDEN:'il_listen');
    config      likeds(il_config);
    servlet     pointer(*PROC) value;    
end-pr;

///
// Write response
//
// Writes the passed buffer to the HTTP message. This procedure can be called
// multiple times for a single HTTP response. The buffers content will be
// concated to a single HTTP message body.
//
// @param Response
// @param Response message content.
//
// @info The response data structure must be filled with the correct values
//       (f. e. the HTTP status code) for the response on the first call of
//       this procedure for the HTTP response.
///
dcl-pr il_responseWrite extproc(*CWIDEN:'il_responseWrite');
    response    likeds(il_response);
    buffer      varchar(524284:4) ccsid(*utf8) options(*varsize) const ;    
end-pr;

///
// Write binary response
//
// Writes the passed buffer to the HTTP message. This procedure can be called
// multiple times for a single HTTP response. The buffers content will be
// concated to a single HTTP message body. The content of the message will be
// written as is to the HTTP message without any character conversion.
//
// @param Response
// @param Response message content.
//
// @info The response data structure must be filled with the correct values
//       (f. e. the HTTP status code) for the response on the first call of
//       this procedure for the HTTP response.
///
dcl-pr il_responseWriteBin extproc(*CWIDEN:'il_responseWrite');
    response    likeds(il_response);
    buf         varchar(524284:4) options(*varsize) const ;    
end-pr;

///
// Serve file
//
// Writes the content of the file to the response message.
//
// @param Response
// @param Filename
///
dcl-pr il_serveStatic ind extproc(*CWIDEN:'il_serveStatic');
    response    likeds(il_response);
    fileName    varchar(256) options(*varsize) const;    
end-pr;

///
// Write stream 
//
// Writes the content of the stream to the response message.
//
// @param Response
// @param Stream
///
dcl-pr il_responseWriteStream extproc(*CWIDEN:'il_responseWriteStream');
    response    likeds(il_response);
    stream      pointer value; // Pointer returned by i.e. json_stream from noxDB
end-pr;