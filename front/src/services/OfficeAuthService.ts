import {
    AccountInfo,
    AuthenticationResult,
    EndSessionRequest,
    InteractionRequiredAuthError,
    PublicClientApplication,
    RedirectRequest,
    SilentRequest
} from "@azure/msal-browser";
import {apiScope, appId, connectionScopes, IssuerURL, msalConfig, redirectUri, tenantJWKSURI} from "../config";
import Axios, {AxiosResponse} from "axios";
import {IJWKSKeys} from "../interfaces/IJWKSKeys";

export class AuthService {
    private myMSALObj: PublicClientApplication;
    private account: AccountInfo | null;

    constructor() {
        this.myMSALObj = new PublicClientApplication(msalConfig);
        this.account = null;
    }

    handleRedirectPromise(): Promise<AuthenticationResult | null> {
        return this.myMSALObj.handleRedirectPromise();
    }

    handleResponse(response: AuthenticationResult | null): AccountInfo | null {
        if (response !== null) {
            this.account = response.account;
        } else {
            this.account = this.getAccount();
        }
        return this.account;
    }

    login() {
        const loginRedirectRequest: RedirectRequest = {
            scopes: connectionScopes,
            redirectStartPage: redirectUri,
            prompt: "select_account"
        }
        return this.myMSALObj.loginRedirect(loginRedirectRequest);
    }

    logout() {
        if (this.account) {
            const logOutRequest: EndSessionRequest = {
                account: this.account,
                postLogoutRedirectUri: redirectUri
            };
            return this.myMSALObj.logout(logOutRequest);
        }
    }

    async getToken(): Promise<string> {
        if (this.account) {
            let silentProfileRequest: SilentRequest = {
                scopes: [apiScope],
                account: this.account,
                forceRefresh: false
            };
            return this.getTokenSilent(silentProfileRequest);
        }
        return "";
    }

    getAccount(): AccountInfo | null {
        const currentAccounts = this.myMSALObj.getAllAccounts();

        if (currentAccounts === null) {
            return null;
        } else {
            return currentAccounts[0];
        }
    }

    private async getTokenSilent(silentRequest: SilentRequest): Promise<string> {
        try {
            const response = await this.myMSALObj.acquireTokenSilent(silentRequest);
            return response.accessToken;
        } catch (e) {
            if (e instanceof InteractionRequiredAuthError) {
                console.log("Redirection needed");
            } else {
                console.error(e);
            }
        }
        return "";
    }
}

export const authServiceObj: AuthService = new AuthService();