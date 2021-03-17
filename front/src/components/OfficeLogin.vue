<template>
  <div class="flex flex-col space-y-4">
    <button
      type="button"
      v-on:click="officeSignIn"
      class="flex items-center cursor-pointer justify-center py-2 space-x-2 transition-colors duration-300 border border-blue-500 rounded-md group hover:bg-blue-500 focus:outline-none"
    >
      <span>
        <!-- OFFICE ICON -->
        <svg
          version="1.1"
          id="Capa_1"
          xmlns="http://www.w3.org/2000/svg"
          xmlns:xlink="http://www.w3.org/1999/xlink"
          x="0px"
          y="0px"
          viewBox="0 0 512 512"
          style="enable-background: new 0 0 512 512"
          width="2vh"
          height="2vh"
          xml:space="preserve"
        >
          <path
            style="fill: #4caf50"
            d="M272,240h240V16c0-8.832-7.168-16-16-16H272V240z"
          />
          <path
            style="fill: #f44336"
            d="M240,240V0H16C7.168,0,0,7.168,0,16v224H240z"
          />
          <path
            style="fill: #2196f3"
            d="M240,272H0v224c0,8.832,7.168,16,16,16h224V272z"
          />
          <path
            style="fill: #ffc107"
            d="M272,272v240h224c8.832,0,16-7.168,16-16V272H272z"
          />
        </svg>
      </span>
      <span
        class="text-sm mt-1 font-medium text-blue-500 group-hover:text-white"
        >Office</span
      >
    </button>
    <span v-if="errorMessages" class="text-sm font-semibold text-red-500">{{errorMessages}}</span>
  </div>
</template>

<script lang="ts">
import { ref, defineComponent } from 'vue'
import axios from 'axios'
import { AccountInfo, AuthenticationResult } from '@azure/msal-browser'
import { authServiceObj } from '../services/OfficeAuthService'
import { baseUri } from '../config'
import currentUser from '../services/UserService'

export default defineComponent({
  name: "OfficeLogin",
  data() {
    return {
      loginInitialState: true,
      errorMessage: ''
    };
  },
  async mounted() {
    let res: AuthenticationResult | null = null;

    try {
      res = await authServiceObj.handleRedirectPromise();
    } catch (error) {
      console.log(error);
      return;
    }

    const account: AccountInfo | null = authServiceObj.handleResponse(res);
    if (account) {
      await this.getUserProfile();
    } else {
      this.loginInitialState = false;
    }
  },

  methods: {
    // MANAGE SIGN-IN WITH OFFICE
    async officeSignIn() {
      try {
        await authServiceObj.login();
      } catch (error) {
        console.log(error);
      }
    },

    // GET OFFICE ACCOUNT INFOS
    async getUserProfile() {
      let accessToken: string = await authServiceObj.getToken();
      if (accessToken === "") {
        this.loginInitialState = false;
      }
      this.loginInitialState = true;

      console.log("OFFICE TOKEN = " + accessToken);
      try {
        const ret = await axios.post(baseUri +'/auth/office-jwt', {}, {
          headers: {
            authorization: `Bearer ${accessToken}`,
          },
        });
        console.log(ret);
        currentUser.connect(ret.data.token)
        this.$router.push('/dashboard');
      } catch (error) {
        console.log(error);
        if (error.response.status == 500)
          this.errorMessages = 'Server Error.';
      }
    },
  },
});
</script>

<style scoped>
a {
  color: #42b983;
}
</style>