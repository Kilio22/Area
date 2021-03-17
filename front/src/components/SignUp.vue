<template>
  <div class="flex items-center min-h-screen p-6 bg-gray-100 lg:justify-center">
    <div class="container mx-auto root">
      <!-- AREA LOGO -->
      <img
        class="mx-auto w-auto object-fit:contain max-w-sm mb-10"
        src="../assets/AREALOGO.png"
      />
      <!-- CARD -->
      <div
        class="mx-auto overflow-hidden bg-white rounded-md shadow-lg max-w-md"
      >
        <div class="p-5 md:flex-1">
          <!-- CARD HEADER -->
          <h3 class="my-4 text-2xl font-semibold text-gray-700">
            Create account
          </h3>
          <form action="#" class="flex flex-col space-y-5">
            <!-- USERNAME INPUT -->
            <div class="flex flex-col space-y-1">
              <div class="flex items-center justify-between">
                <label
                  for="password"
                  class="text-md font-semibold text-gray-500"
                  >Username</label
                >
              </div>
              <input
                type="text"
                v-model="username"
                class="px-4 py-2 transition duration-300 border border-gray-300 rounded focus:border-transparent focus:outline-none focus:ring-4 focus:ring-blue-200"
              />
              <span
                v-if="errorMessages.username"
                class="text-sm font-semibold text-red-500"
                >{{ errorMessages.username }}</span
              >
            </div>
            <!-- EMAIL INPUT -->
            <div class="flex flex-col space-y-1">
              <div class="flex items-center justify-between">
                <label
                  for="password"
                  class="text-md font-semibold text-gray-500"
                  >Email</label
                >
              </div>
              <input
                type="text"
                v-model="email"
                class="px-4 py-2 transition duration-300 border border-gray-300 rounded focus:border-transparent focus:outline-none focus:ring-4 focus:ring-blue-200"
              />
              <span
                v-if="errorMessages.email"
                class="text-sm font-semibold text-red-500"
                >{{ errorMessages.email }}</span
              >
            </div>
            <!-- PASSWORD INPUT -->
            <div class="flex flex-col space-y-1">
              <div class="flex items-center justify-between">
                <label
                  for="password"
                  class="text-md font-semibold text-gray-500"
                  >Password</label
                >
              </div>
              <input
                type="password"
                v-model="password"
                class="px-4 py-2 transition duration-300 border border-gray-300 rounded focus:border-transparent focus:outline-none focus:ring-4 focus:ring-blue-200"
              />
              <span
                v-if="errorMessages.password"
                class="text-sm font-semibold text-red-500"
                >{{ errorMessages.password }}</span
              >
            </div>
            <!-- SIGN-UP BUTTON -->
            <div>
              <button
                type="button"
                v-on:click="signUp"
                v-bind:disabled="checkInputs() == false"
                class="disabled:opacity-50 w-full px-4 py-2 text-lg font-semibold text-white transition-colors duration-300 bg-blue-500 rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-blue-200 focus:ring-4"
              >
                Sign-Up
              </button>
              <span
                v-if="errorMessages.request"
                class="text-sm font-semibold text-red-500"
                >{{ errorMessages.request }}</span
              >
            </div>
          </form>
        </div>
      </div>
      <footer>
        <h6 class="text-sm font-medium mt-8 -mb-24">© 2021 Chad Corporation</h6>
      </footer>
    </div>
  </div>
</template>

<script lang="ts">
import { ref, defineComponent } from "vue";
import axios from "axios";
import { baseUri } from "../config";

export default defineComponent({
  name: "SignUp",
  setup: () => {
    const count = ref(0);
    return { count };
  },
  data() {
    return {
      username: "",
      email: "",
      password: "",

      errorMessages: [],
    };
  },
  watch: {
    username(value) {
      this.validateUsername();
    },
    email(value) {
      this.validateEmail();
    },
    password(value) {
      this.validatePassword();
    },
  },
  methods: {
    // CHECK IF USERNAME IS ALPHANUMERICAL
    validateUsername() {
      let regexUsername = /^[a-zA-Z0-9]*$/;
      if (!regexUsername.test(this.username))
        this.errorMessages["username"] = "Invalid username.";
      else if (this.username.length < 3)
        this.errorMessages["username"] = "Too short username.";
      else this.errorMessages["username"] = "";
    },

    // CHECK IF EMAIL IS WELL FORMATTED
    validateEmail() {
      let regexEmail = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      if (!regexEmail.test(this.email))
        this.errorMessages["email"] = "Invalid email address.";
      else this.errorMessages["email"] = "";
    },

    // CHECK IF PASSWORD IS LONG ENOUGH
    validatePassword() {
      if (this.password.length < 6)
        this.errorMessages["password"] = "Too short password.";
      else this.errorMessages["password"] = "";
    },

    // CHECK IF INPUTS ARE FILLED AND VALIDS
    checkInputs() {
      if (!this.username || !this.email || !this.password) return false;

      if (
        this.errorMessages["username"] ||
        this.errorMessages["email"] ||
        this.errorMessages["password"]
      )
        return false;
      return true;
    },

    // CALL SERVER FOR SIGN-UP
    async signUp() {
      console.log(this.username + " wants to create an account");
      try {
        const ret = await axios.post(baseUri + "/auth/sign-up", {
          username: this.username,
          email: this.email,
          password: this.password,
        });
        console.log(ret);
        this.$router.push("signin");
      } catch (error) {
        console.log(error);
        if (error.response.status == 409)
          this.errorMessages["request"] =
            "A user with the given email already exists.";
        if (error.response.status == 500)
          this.errorMessages["request"] = "Server Error.";
      }
    },
  },
});
</script>

<style scoped>
a {
  color: #42b983;
}
.root {
  margin-top: 25px;
}
</style>