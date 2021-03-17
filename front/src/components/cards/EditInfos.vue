<template>
  <div class="flex min-h-screen bg-gray-100 lg:justify-center">
    <div class="my-3 px-3 w-full">
      <!-- CARD EDIT INFOS -->
      <div class="mx-auto bg-white rounded-md shadow-lg md:w-1/4 mt-20">
        <div class="p-5 ">
          <!-- HEADER -->
          <h3 class="my-4 text-xl font-semibold text-gray-700">Edit account informations</h3>
          <form action="#" class="flex flex-col space-y-5">
            <!-- USERNAME INPUT -->
            <div class="flex flex-col space-y-1">
              <div class="flex items-center justify-between">
                <label for="password" class="text-md font-semibold text-gray-500">Username</label>
              </div>
              <input
                type="text"
                v-model="username"
                class="px-4 py-2 transition duration-300 border border-gray-300 rounded focus:border-transparent focus:outline-none focus:ring-4 focus:ring-blue-200"
              />
              <span v-if="errorMessages.username" class="text-sm font-semibold text-red-500">{{errorMessages.username}}</span>
            </div>
            <!-- EMAIL INPUT -->
            <div class="flex flex-col space-y-1">
              <div class="flex items-center justify-between">
                <label for="password" class="text-md font-semibold text-gray-500">Email</label>
              </div>
              <input
                type="text"
                v-model="email"
                class="px-4 py-2 transition duration-300 border border-gray-300 rounded focus:border-transparent focus:outline-none focus:ring-4 focus:ring-blue-200"
              />
              <span v-if="errorMessages.email" class="text-sm font-semibold text-red-500">{{errorMessages.email}}</span>
            </div>
            <!-- PASSWORD INPUT -->
            <div class="flex flex-col space-y-1">
              <div class="flex items-center justify-between">
                <label for="password" class="text-md font-semibold text-gray-500">Password</label>
              </div>
              <input
                type="password"
                v-model="password"
                class="px-4 py-2 transition duration-300 border border-gray-300 rounded focus:border-transparent focus:outline-none focus:ring-4 focus:ring-blue-200"
              />
            </div>
            <span v-if="errorMessages.password" class="text-sm font-semibold text-red-500">{{errorMessages.password}}</span>
            <!-- CONFIRM BUTTON -->
            <div>
              <button
                type="button"
                v-on:click="editInfos"
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
  name: 'EditInfos',
  setup: () => {
    const count = ref(0)
    return { count }
  },
  data() {
    return {
      username: '',
      email: '',
      password: '',
      errorMessages: [],
      successMessage: ''
    }
  },
  watch: {
    username(value){
      this.validateUsername();
    },
    email(value){
      this.validateEmail();
    },
    password(value){
      this.validatePassword();
    },
  },
  methods: {
    // CHECK IF USERNAME IS ALPHANUMERICAL
    validateUsername() {
      let regexUsername = /^[a-zA-Z0-9]*$/;
      if (!regexUsername.test(this.username))
        this.errorMessages['username'] = 'Invalid username.';
      else if (this.username.length < 3)
        this.errorMessages['username'] = 'Too short username.';
      else
        this.errorMessages['username'] = '';
    },

    // CHECK IF EMAIL IS WELL FORMATTED
    validateEmail() {
      let regexEmail = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      if (!regexEmail.test(this.email))
        this.errorMessages['email'] = 'Invalid email address.';
      else
        this.errorMessages['email'] = '';
    },

    // CHECK IF PASSWORD IS LONG ENOUGH
    validatePassword() {
      if (this.password.length < 6)
        this.errorMessages['password'] = 'Too short password.';
      else
        this.errorMessages['password'] = '';
    },

    // CHECK IF INPUTS ARE FILLED AND VALIDS
    checkInputs() {
      if (!this.username || !this.email || !this.password)
        return false

      if (this.errorMessages['username'] || this.errorMessages['email'] || this.errorMessages['password'])
        return false
      return true
    },

    // EDIT USERNAME/EMAIL
    async editInfos() {
      try {
        await axios.put(baseUri + "/profile",
        {
          displayName: this.username,
          email: this.email
        },
        {
          headers: {
            authorization: `Bearer ${currentUser.jwt}`,
          },
        });
        this.successMessage = 'Information succesfully changed!'
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
</style>
