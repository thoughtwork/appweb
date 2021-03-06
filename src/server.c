/*
    server.c -- Manage a web server with one or more virtual hosts.

    A server supports multiple endpoints and one or more (virtual) hosts.
    Server Servers may be configured manually or via an "appweb.conf" configuration  file.

    Copyright (c) All Rights Reserved. See copyright notice at the bottom of the file.
 */

/********************************** Includes **********************************/

#include    "appweb.h"

/***************************** Forward Declarations ***************************/

static void manageAppweb(MaAppweb *appweb, int flags);

/************************************ Code ************************************/
/*
    Create the top level appweb control object. This is typically a singleton.
 */
PUBLIC MaAppweb *maCreateAppweb()
{
    MaAppweb    *appweb;
    Http        *http;

    if ((appweb = mprAllocObj(MaAppweb, manageAppweb)) == NULL) {
        return 0;
    }
    MPR->appwebService = appweb;
    appweb->http = http = httpCreate(HTTP_CLIENT_SIDE | HTTP_SERVER_SIDE);
    httpSetContext(http, appweb);
    appweb->servers = mprCreateList(-1, MPR_LIST_STABLE);
    maParseInit(appweb);
    /* 
       Open the builtin handlers 
     */
#if ME_COM_DIR
    maOpenDirHandler(http);
#endif
    maOpenFileHandler(http);
    return appweb; 
}


static void manageAppweb(MaAppweb *appweb, int flags)
{
    if (flags & MPR_MANAGE_MARK) {
        mprMark(appweb->defaultServer);
        mprMark(appweb->servers);
        mprMark(appweb->directives);
        mprMark(appweb->http);
    }
}


PUBLIC void maAddServer(MaAppweb *appweb, MaServer *server)
{
    mprAddItem(appweb->servers, server);
}


PUBLIC void maSetDefaultServer(MaAppweb *appweb, MaServer *server)
{
    appweb->defaultServer = server;
}


PUBLIC MaServer *maLookupServer(MaAppweb *appweb, cchar *name)
{
    MaServer    *server;
    int         next;

    for (next = 0; (server = mprGetNextItem(appweb->servers, &next)) != 0; ) {
        if (strcmp(server->name, name) == 0) {
            return server;
        }
    }
    return 0;
}


PUBLIC int maStartAppweb(MaAppweb *appweb)
{
    httpStartEndpoints();
    mprLog(1, "Started at %s", mprGetDate(0));
    return 0;
}


PUBLIC int maStopAppweb(MaAppweb *appweb)
{
    httpStopConnections(0);
    httpStopEndpoints();
    return 0;
}


static void manageServer(MaServer *server, int flags)
{
    if (flags & MPR_MANAGE_MARK) {
        mprMark(server->name);
        mprMark(server->appweb);
        mprMark(server->http);
        mprMark(server->defaultHost);
        mprMark(server->limits);
        mprMark(server->endpoints);
    }
}


/*  
    Create a new server. A server may manage may multiple servers and virtual hosts. 
    If ip/port endpoint is supplied, this call will create a Server on that endpoint. Otherwise, 
    maConfigureServer should be called later. A default route is created with the document root set to "."
 */
PUBLIC MaServer *maCreateServer(MaAppweb *appweb, cchar *name)
{
    MaServer    *server;
    HttpHost    *host;
    HttpRoute   *route;

    assert(appweb);

    if ((server = mprAllocObj(MaServer, manageServer)) == NULL) {
        return 0;
    }
    if (name == 0 || *name == '\0') {
        name = "default";
    }
    server->name = sclone(name);
    server->endpoints = mprCreateList(-1, MPR_LIST_STABLE);
    server->limits = httpCreateLimits(1);
    server->appweb = appweb;
    server->http = appweb->http;

    server->defaultHost = host = httpCreateHost();
    if (!httpGetDefaultHost()) {
        httpSetDefaultHost(host);
    }
    route = httpCreateRoute(host);
    httpSetRouteName(route, "default");
    httpSetHostDefaultRoute(host, route);
    route->limits = server->limits;

    maAddServer(appweb, server);
    if (appweb->defaultServer == 0) {
        maSetDefaultServer(appweb, server);
    }
    return server;
}


/*
    Configure the server. If the configFile is defined, use it. If not, then consider home, documents, ip and port.
 */
PUBLIC int maConfigureServer(MaServer *server, cchar *configFile, cchar *home, cchar *documents, cchar *ip, int port, int flags)
{
    MaAppweb        *appweb;
    Http            *http;
    HttpEndpoint    *endpoint;
    HttpHost        *host;
    HttpRoute       *route;
    char            *path;

    appweb = server->appweb;
    http = appweb->http;

    /* Suppress conditional compilation warnings */
    mprNop(appweb);
    mprNop(http);

    if (configFile) {
        path = mprGetAbsPath(configFile);
        if (maParseConfig(server, path, 0) < 0) {
            /* mprError("Cannot configure server using %s", path); */
            return MPR_ERR_CANT_INITIALIZE;
        }
        return 0;

    } else {
        if ((endpoint = httpCreateConfiguredEndpoint(server->defaultHost, home, documents, ip, port)) == 0) {
            return MPR_ERR_CANT_OPEN;
        }
        maAddEndpoint(server, endpoint);
        host = mprGetFirstItem(endpoint->hosts);
        assert(host);
        route = host->defaultRoute;
        assert(route);

        if (home) {
            httpSetRouteHome(route, home);
        }
        if (!(flags & MA_NO_MODULES)) {
#if ME_COM_CGI
            maLoadModule(appweb, "cgiHandler", "libmod_cgi");
            if (httpLookupStage(http, "cgiHandler")) {
                httpAddRouteHandler(route, "cgiHandler", "cgi cgi-nph bat cmd pl py");
                /*
                    Add cgi-bin with a route for the /cgi-bin URL prefix.
                 */
                path = "cgi-bin";
                if (mprPathExists(path, X_OK)) {
                    HttpRoute *cgiRoute;
                    cgiRoute = httpCreateAliasRoute(route, "/cgi-bin/", path, 0);
                    mprTrace(4, "ScriptAlias \"/cgi-bin/\":\"%s\"", path);
                    httpSetRouteHandler(cgiRoute, "cgiHandler");
                    httpFinalizeRoute(cgiRoute);
                }
            }
#endif
#if ME_COM_ESP || ME_ESP_PRODUCT
            maLoadModule(appweb, "espHandler", "libmod_esp");
            if (httpLookupStage(http, "espHandler")) {
                httpAddRouteHandler(route, "espHandler", "esp");
            }
#endif
#if ME_COM_EJS || ME_EJS_PRODUCT
            maLoadModule(appweb, "ejsHandler", "libmod_ejs");
            if (httpLookupStage(http, "ejsHandler")) {
                httpAddRouteHandler(route, "ejsHandler", "ejs");
            }
#endif
#if ME_COM_PHP
            maLoadModule(appweb, "phpHandler", "libmod_php");
            if (httpLookupStage(http, "phpHandler")) {
                httpAddRouteHandler(route, "phpHandler", "php");
            }
#endif
            httpAddRouteHandler(route, "fileHandler", "");
        }
    }
    return 0;
}


PUBLIC int maStartServer(MaServer *server)
{
    HttpEndpoint    *endpoint;
    int             next, count, warned;

    warned = 0;
    count = 0;
    for (next = 0; (endpoint = mprGetNextItem(server->endpoints, &next)) != 0; ) {
        if (httpStartEndpoint(endpoint) < 0) {
            warned++;
            break;
        } else {
            count++;
        }
    }
    if (count == 0) {
        if (!warned) {
            mprError("Server is not listening on any addresses");
        }
        return MPR_ERR_CANT_OPEN;
    }
    if (warned) {
        return MPR_ERR_CANT_OPEN;        
    }
    return 0;
}


PUBLIC void maStopServer(MaServer *server)
{
    HttpEndpoint    *endpoint;
    int             next;

    for (next = 0; (endpoint = mprGetNextItem(server->endpoints, &next)) != 0; ) {
        httpStopEndpoint(endpoint);
    }
}


//  TODO - why does appweb need to keep per-server endpoint lists?
PUBLIC void maAddEndpoint(MaServer *server, HttpEndpoint *endpoint)
{
    mprAddItem(server->endpoints, endpoint);
}


PUBLIC void maRemoveEndpoint(MaServer *server, HttpEndpoint *endpoint)
{
    mprRemoveItem(server->endpoints, endpoint);
}


/*
    Set the document root for the default server
 */
PUBLIC void maSetServerAddress(MaServer *server, cchar *ip, int port)
{
    HttpEndpoint    *endpoint;
    int             next;

    for (next = 0; ((endpoint = mprGetNextItem(server->endpoints, &next)) != 0); ) {
        httpSetEndpointAddress(endpoint, ip, port);
    }
}



/*
    Load a module. Returns 0 if the modules is successfully loaded (may have already been loaded).
 */
PUBLIC int maLoadModule(MaAppweb *appweb, cchar *name, cchar *libname)
{
    MprModule   *module;
    char        entryPoint[ME_MAX_FNAME];
    char        *path;

    if (strcmp(name, "authFilter") == 0 || strcmp(name, "rangeFilter") == 0 || strcmp(name, "uploadFilter") == 0 ||
            strcmp(name, "fileHandler") == 0 || strcmp(name, "dirHandler") == 0) {
        mprLog(1, "The %s module is now builtin. No need to use LoadModule", name);
        return 0;
    }
    if ((module = mprLookupModule(name)) != 0) {
#if ME_STATIC
        mprLog(MPR_INFO, "Activating module (Builtin) %s", name);
#endif
        return 0;
    }
    if (libname == 0) {
        path = sjoin("mod_", name, ME_SHOBJ, NULL);
    } else {
        path = sclone(libname);
    }
    fmt(entryPoint, sizeof(entryPoint), "ma%sInit", stitle(name));
    entryPoint[2] = toupper((uchar) entryPoint[2]);
    if ((module = mprCreateModule(name, path, entryPoint, MPR->httpService)) == 0) {
        return 0;
    }
    if (mprLoadModule(module) < 0) {
        return MPR_ERR_CANT_CREATE;
    }
    return 0;
}

 
PUBLIC HttpAuth *maGetDefaultAuth(MaServer *server)
{
    return server->defaultHost->defaultRoute->auth;
}


/*
    @copy   default

    Copyright (c) Embedthis Software LLC, 2003-2014. All Rights Reserved.

    This software is distributed under commercial and open source licenses.
    You may use the Embedthis Open Source license or you may acquire a 
    commercial license from Embedthis Software. You agree to be fully bound
    by the terms of either license. Consult the LICENSE.md distributed with
    this software for full details and other copyrights.

    Local variables:
    tab-width: 4
    c-basic-offset: 4
    End:
    vim: sw=4 ts=4 expandtab

    @end
 */
