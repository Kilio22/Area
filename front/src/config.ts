import { Configuration, LogLevel } from '@azure/msal-browser';

export const appId: string = '<YOUR_APP_ID>';
export const baseUri: string = 'http://localhost:8080';
export const redirectUri: string = 'http://localhost:8081/signin';
export const apiScope: string = 'api://<YOUR_SERVER_APP_ID>/user.base.read';

export const tenantJWKSURI: string = 'https://login.microsoftonline.com/<YOUR_TENANT_ID>/discovery/v2.0/keys';
export const IssuerURL: string = 'https://login.microsoftonline.com/<YOUR_TENANT_ID>/v2.0';

export const connectionScopes: string[] = [
    apiScope,
];

export const msalConfig: Configuration = {
    auth: {
        clientId: appId,
        redirectUri: redirectUri,
        authority: 'https://login.microsoftonline.com/<YOUR_TENANT_ID>'
    },
    cache: {
        cacheLocation: 'localStorage',
        storeAuthStateInCookie: true
    },
    system: {
        loggerOptions: {
            loggerCallback: (level: LogLevel, message: string, containsPii: boolean): void => {
                if (containsPii) {
                    return;
                }
                switch (level) {
                    case LogLevel.Error:
                        console.log(message);
                        return;
                    case LogLevel.Info:
                        console.log(message);
                        return;
                    case LogLevel.Verbose:
                        console.log(message);
                        return;
                    case LogLevel.Warning:
                        console.log(message);
                        return;
                }
            }
        }
    }
};