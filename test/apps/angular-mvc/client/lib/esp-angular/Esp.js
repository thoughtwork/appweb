/*
    esp.js - Esp Angular Extension
 */
'use strict';
/*
    The Esp service provide a central place for ESP state.
    It places a "Esp" object on the $rootScope that is inherited by all $scopes.
    Alternatively, injecting the Esp service provides direct access using the Esp service object.
 */
angular.module('esp', ['esp.click', 'esp.field-errors', 'esp.format', 'esp.input-group', 'esp.input', 
                       'esp.resource', 'esp.session', 'esp.titlecase'])

.config(function() {
    /*
        Extract the route configuration data.
     */
    var e = angular.element(document.getElementById('body'));
    var esp = angular.module('esp');
    esp.$config = JSON.parse(e.attr('data-config'));
    /* URL resolution for ngRoute templates */
    esp.url = function(url) {
        return esp.$config.appPrefix + url;
    }

}).factory('Esp', function(SessionStore, $document, $http, $location, $rootScope, $timeout) {

    var Esp = { config: angular.module('esp').$config };
    $rootScope.Esp = Esp;

    var boot_map = {
        inform: 'info',
        error: 'danger', 
        warning: 'warning',
        success: 'success',
    };

    Esp.bootclass = function(kind) {
        return boot_map[kind];
    }

    /*
        Is this user authorized to perform the given task
        Note: this is advisory only to provide hints in the UI. It is the server's repsonsibility to
        restrict user abilities as appropriate.
     */
    Esp.can = function(task) {
        var user = Esp.user
        return (user && user.abilities && user.abilities[task]);
    };

    /*
        Empty controller constructor
     */
    Esp.empty = function() {
        return function() {}
    };

    Esp.error = function (str) {
        $rootScope.feedback = { error: str };
    };

    var fa_map = {
        success: 'fa-plus',
        inform: 'fa-plus',
        warning: 'fa-bell',
        error: 'fa-bolt', 
        critical: 'fa-bolt', 
    };

    Esp.faclass = function(kind) {
        return fa_map[kind];
    }

    Esp.inform = function (str) {
        $rootScope.feedback = { inform: str };
    };

    Esp.lighten = function (color, percent) {   
        color = '' + color;
        var num = parseInt(color.slice(1),16), amt = Math.round(2.55 * percent), R = (num >> 16) + amt, B = (num >> 8 & 0x00FF) + amt, G = (num & 0x0000FF) + amt;
        return "#" + (0x1000000 + (R<255?R<1?0:R:255)*0x10000 + (B<255?B<1?0:B:255)*0x100 + (G<255?G<1?0:G:255)).toString(16).slice(1);
    };

    Esp.loadScript = function(url, callback) {
        if (!Esp.scriptCache) {
            Esp.scriptCache = {};
        }
        if (Esp.scriptCache[url]) {
            if (callback) {
                callback();
            }
            return;
        }
        console.log("LoadScript ", url);
        $http.get(url).success(function(data, status, headers, config) {
            var script = document.createElement('script');
            script.type = 'text/javascript';
            script.src = url;
            document.body.appendChild(script);
            if (callback) {
                callback();
            }
        }).error(function(data, status, headers, config) {
            console.log("ERROR");

        });
    };

    Esp.login = function(user) {
        if (user) {
            Esp.user = user;
            Esp.user.lastAccess = Date.now();
            SessionStore.put('user', Esp.user);
        }
    };

    Esp.logout = function() {
        SessionStore.remove('user');
        Esp.user = null;
    };

    Esp.rgb2hex = function(color) {
        if (!color) {
            color = 'rgb(0,0,0)';
        }
        var matches = color.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)/);
        if (!matches) {
            matches = color.match(/^rgba\((\d+),\s*(\d+),\s*(\d+)/);
        }
        if (!matches) {
            return '#000';
        }
        function hex(x) {
            return ("0" + parseInt(x).toString(16)).slice(-2);
        }
        return "#" + hex(matches[1]) + hex(matches[2]) + hex(matches[3]);
    };

    /*
        Map a string to TitleCase
     */
    Esp.titlecase = function (str) {
        var words = str.split(/[ \.]/g);
        for (var i = 0; i < words.length; i++) {
            words[i] = words[i].charAt(0).toUpperCase() + words[i].slice(1);
        }
        return words.join(' ');
    };

    Esp.url = function (url) {
        return Esp.config.appPrefix + url;
    }

    /******* body ********/
    /*
        Recover the user session information. The server still validates.
     */
    if (Esp.config.login && Esp.config.login.name) {
        Esp.login(Esp.config.login);
        Esp.user.auto = true;
    } else {
        Esp.user = SessionStore.get('user') || null;
        Esp.user.lastAccess = Date().now;
    }
    if (Esp.user.length == 0) {
        Esp.user = null;
    }
    /*
        Remember the referrer in route changes
     */
    $rootScope.$on("$routeChangeSuccess", function(scope, current, previous) {
        Esp.referrer = previous;
    });

    /*
        Whenever the user clicks something, clear the feedback
     */
    $document.bind("click", function(event){
        delete $rootScope.feedback;
        if (Esp.user) {
            Esp.user.lastAccess = Date.now();
            // console.log("Update last access", Esp.user.lastAccess);
        }
        return true;
    });

    /*
        Login session timeout
     */
    function sessionTimeout() {
        var timeout = Esp.config.timeouts.session * 1000;
        if (Esp.user && Esp.user.lastAccess && !Esp.user.auto) {
            if ((Date.now() - Esp.user.lastAccess) > timeout) {
                $rootScope.feedback = { error: "Login Session Expired"};
                console.log("Session time expired. Log out");
                Esp.logout();
            } else {
                if ((Date.now() - Esp.user.lastAccess) > (timeout - (60 * 1000))) {
                    $rootScope.feedback = { warning: "Session Will Soon Expire"};
                }
                console.log("Session time remaining: ", (timeout - ((Date.now() - Esp.user.lastAccess))) / 1000, "secs");
            }
        }
        $timeout(sessionTimeout, 60 * 1000, true);
    }
    $timeout(sessionTimeout, 0, true);
    return Esp;
})
.config(function($httpProvider, $routeProvider) {
    /*
        Define an Http interceptor to redirect 401 responses to the login page
     */
    $httpProvider.interceptors.push(function($location, $q, $rootScope, $window) {
        return {
            response: function (response) {
                if (response.data && response.data.feedback) {
                    $rootScope.feedback = response.data.feedback;
                }
                return response;
            },
            responseError: function (response) {
                if (response <= 0 || response.status >= 500) {
                    $rootScope.feedback = { warning: "Server Error. Please Retry." };
                } else if (response.status === 401) {
                    /* Must use esp module as Esp depends on this */
                    var espModule = angular.module('esp');
                    if (espModule.$config.loginRequired) {
                        $rootScope.Esp.user = null;
                        $location.path(espModule.$config.loginRequired);
                    } else {
                        $rootScope.Esp.user = null;
                        $rootScope.feedback = response.data.feedback;
                    }
                } else if (response.status >= 400) {
                    $rootScope.feedback = { warning: "Request Error: " + response.status + ", for " + response.config.url};
                } else if (response.data && response.data.feedback) {
                    $rootScope.feedback = response.feedback;
                }
                return $q.reject(response);
            }
        };
    });
});

/*
    Route resolve function for routes to verify the user's defined abilities
    This function is required at config time and so must be added to the esp module instead of Esp.
 */
var esp = angular.module('esp');
esp.checkAuth = function($q, $location, $rootScope, $route, Esp) {
    var requiredAbilities = $route.current.$$route.abilities;
    var user = Esp.user
    for (var ability in requiredAbilities) {
        if (user && user.abilities && user.abilities[ability] == null) {
            if ($location.path() != "/") {
                $rootScope.feedback = { inform: "Insufficient Privilege"};
                $location.path(Esp.lastLocation || "/");
                return $q.reject($rootScope.feedback);
            }
        }
    }
    Esp.lastLocation = $location.path();
    if (user) {
        user.lastAccess = Date.now();
    }
    return true;
}
