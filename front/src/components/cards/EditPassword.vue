<template>
  <div class="flex min-h-screen bg-gray-100 lg:justify-center">
    <div class="my-3 px-3 w-full">
      <!-- CARD EDIT PASSWORD -->
      <div class="mx-auto bg-white rounded-md shadow-lg md:w-1/4 mb-20">
        <div class="p-5">
          <!-- HEADER -->
          <h3 class="my-4 text-xl font-semibold text-gray-700">Edit password</h3>
          <form action="#" class="flex flex-col space-y-5">
            <!-- CURRENT PASSWORD INPUT -->
            <div class="flex flex-col space-y-1">
              <div class="flex items-center justify-between">
                <label class="text-md font-semibold text-gray-500">Current password</label>
              </div>
              <input
                type="password"
                v-model="password"
                class="px-4 py-2 transition duration-300 border border-gray-300 rounded focus:border-transparent focus:outline-none focus:ring-4 focus:ring-blue-200"
              />
            </div>
            <span v-if="errorMessages.password" class="text-sm font-semibold text-red-500">{{errorMessages.password}}</span>
            <!-- NEW PASSWORD INPUT -->
            <div class="flex flex-col space-y-1">
              <div class="flex items-center justify-between">
                <label for="password" class="text-md font-semibold text-gray-500">New password</label>
              </div>
              <input
                id="password"
                type="password"
                v-model="newPassword"
                class="px-4 py-2 transition duration-300 border border-gray-300 rounded focus:border-transparent focus:outline-none focus:ring-4 focus:ring-blue-200"
              />
              <!-- TOGGLE VISIBILITY BUTTON -->
              <div class="eyeButton">
                  <svg v-on:click="switchVisibility" class="w-8 py-1 px-1 -mt-12" version="1.1" id="Capa_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px"
                    viewBox="0 0 488.85 488.85" style="enable-background:new 0 0 488.85 488.85;" xml:space="preserve">
                    <path d="M244.425,98.725c-93.4,0-178.1,51.1-240.6,134.1c-5.1,6.8-5.1,16.3,0,23.1c62.5,83.1,147.2,134.2,240.6,134.2
                      s178.1-51.1,240.6-134.1c5.1-6.8,5.1-16.3,0-23.1C422.525,149.825,337.825,98.725,244.425,98.725z M251.125,347.025
                      c-62,3.9-113.2-47.2-109.3-109.3c3.2-51.2,44.7-92.7,95.9-95.9c62-3.9,113.2,47.2,109.3,109.3
                      C343.725,302.225,302.225,343.725,251.125,347.025z M248.025,299.625c-33.4,2.1-61-25.4-58.8-58.8c1.7-27.6,24.1-49.9,51.7-51.7
                      c33.4-2.1,61,25.4,58.8,58.8C297.925,275.625,275.525,297.925,248.025,299.625z"
                    />
                  </svg>
              </div>
            </div>
            <span v-if="errorMessages.newPassword" class="text-sm font-semibold text-red-500">{{errorMessages.newPassword}}</span>
            <!-- CONFIRM NEW PASSWORD INPUT -->
            <div class="flex flex-col space-y-1">
              <div class="flex items-center justify-between">
                <label class="text-md font-semibold text-gray-500">Confirm new password</label>
              </div>
              <input
                type="password"
                v-model="newPasswordConfirm"
                class="px-4 py-2 transition duration-300 border border-gray-300 rounded focus:border-transparent focus:outline-none focus:ring-4 focus:ring-blue-200"
              />
            </div>
            <span v-if="errorMessages.newPasswordConfirm" class="text-sm font-semibold text-red-500">{{errorMessages.newPasswordConfirm}}</span>
            <!-- CONFIRM BUTTON -->
            <div>
              <button
                type="button"
                v-on:click="editPassword"
                v-bind:disabled="checkInputs() == false"
                class="disabled:opacity-50 w-full px-4 py-2 text-lg font-semibold text-white transition-colors duration-300 bg-blue-500 rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-blue-200 focus:ring-4"
              >
                Confirm
              </button>
            </div>
              <span v-if="errorMessages.request" class="text-sm font-semibold text-red-500">{{errorMessages.request}}</span>
              <span v-if="successMessage" class="text-md font-semibold text-green-500">{{successMessage}}</span>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { ref, defineComponent } from 'vue';
import axios from "axios";
import { baseUri } from "../../config";
import currentUser from "../../services/UserService";

export default defineComponent({
  name: 'EditPassword',
  setup: () => {
    const count = ref(0)
    return { count }
  },
data() {
    return {
      password: '',
      newPassword: '',
      newPasswordConfirm: '',
      errorMessages: [],
      successMessage: ''
    }
  },
  watch: {
    password(value){
      this.validatePassword();
		},
		newPassword(value){
      this.validateNewPassword();
    },
    newPasswordConfirm(value){
      this.validateNewPasswordConfirm();
    },
  },
  methods: {
    // CHECK IF PASSWORD IS LONG ENOUGH
    validatePassword() {
      if (this.password.length < 6)
        this.errorMessages['password'] = 'Too short password.';
      else
        this.errorMessages['password'] = '';
    },

    // CHECK IF NEW PASSWORD IS LONG ENOUGH AND DIFFERENT
    validateNewPassword() {
      if (this.newPassword.length < 6)
        this.errorMessages['newPassword'] = 'Too short password.';
			if (this.newPassword.localeCompare(this.password) == 0)
        this.errorMessages['newPassword'] = 'Current password and new password are similar.';
      else
        this.errorMessages['newPassword'] = '';
    },
    // CHECK IF NEW PASSWORD IS LONG ENOUGH AND DIFFERENT
    validateNewPasswordConfirm() {
			if (this.newPasswordConfirm.localeCompare(this.newPassword) != 0)
        this.errorMessages['newPasswordConfirm'] = 'Different new password.';
      else
        this.errorMessages['newPasswordConfirm'] = '';
    },

    // CHECK IF INPUTS ARE FILLED AND VALIDS
    checkInputs() {
      if (!this.newPassword || !this.password || !this.newPasswordConfirm)
        return false

      if (this.errorMessages['password'] || this.errorMessages['newPassword'] || this.errorMessages['newPasswordConfirm'])
        return false
      return true
    },

    // TOGGLE PASSWORD VISIBILITY
    switchVisibility() {
      const passwordField = document.querySelector('#password')

      if (passwordField.getAttribute('type') === 'password')
        passwordField.setAttribute('type', 'text')
      else
        passwordField.setAttribute('type', 'password')
    },

    // EDIT UPASSWORD
    async editPassword() {
      try {
        await axios.put(baseUri + "/profile/password",
        {
          password: this.newPassword
        },
        {
          headers: {
            authorization: `Bearer ${currentUser.jwt}`,
          },
        });
        this.successMessage = 'Password succesfully changed!'
      } catch (error) {
        console.log(error);
        if (error.response.status == 500) console.log("500: Server Error");
      }
    },
  }
})
</script>

<style scoped>
a {
  color: #42b983;
}

.eyeButton {
  position: relative;
  display: flex;
  justify-content: flex-end;
}
</style>
