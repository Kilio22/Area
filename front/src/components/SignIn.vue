<template>
  <div class="flex items-center min-h-screen p-4 bg-gray-100 lg:justify-center">
    <div class="container mx-auto root">
      <!-- AREA LOGO -->
      <img
        class="mx-auto max-w-sm w-auto object-fit:contain mb-10"
        src="../assets/AREALOGO.png"
      />
      <!-- CARD -->

      <div
        class="mx-auto overflow-hidden bg-white rounded-md shadow-lg max-w-md"
      >
        <div class="p-5 md:flex-1">
          <!-- CARD HEADER -->
          <h3 class="my-4 text-2xl font-semibold text-gray-700">
            Sign-In to your account
          </h3>
          <form action="#" class="flex flex-col space-y-5">
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
                autofocus
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
            <!-- SIGNIN BUTTON -->
            <div>
              <button
                type="button"
                v-on:click="signIn"
                v-bind:disabled="checkInputs() == false"
                class="disabled:opacity-40 w-full px-4 py-2 text-lg font-semibold text-white transition-colors duration-300 bg-blue-500 rounded-md shadow hover:bg-blue-600 focus:outline-none focus:ring-blue-200 focus:ring-4"
              >
                Sign-In
              </button>
              <span
                v-if="errorMessages.request"
                class="text-sm font-semibold text-red-500"
                >{{ errorMessages.request }}</span
              >
            </div>
            <!-- "OR LOGIN WITH" DIVIDER -->
            <div class="flex flex-col space-y-5">
              <span class="flex items-center justify-center space-x-2">
                <span class="h-px bg-gray-400 w-14"></span>
                <span class="font-normal text-gray-500">or sign-in with</span>
                <span class="h-px bg-gray-400 w-14"></span>
              </span>
              <!-- OFFICE LOGIN BUTTON -->
              <div class="flex flex-col space-y-4">
                <OfficeLogin></OfficeLogin>
                <!-- REGISTER REDIRECT -->
                <span class="h-px"></span>
                <div class="container mx-auto space-y-0.5">
                  <h5 class="font-semibold text-gray-700">First time here?</h5>
                  <router-link
                    to="/signup"
                    v-slot="{ href, route, navigate, isActive, isExactActive }"
                  >
                    <h5 class="font-semibold text-blue-500 cursor-pointer">
                      Create an account
                    </h5>
                  </router-link>
                </div>
              </div>
            </div>
          </form>
        </div>
      </div>
      <footer>
        <h6 class="text-sm font-medium mt-4 -mb-4">© 2021 Chad Corporation</h6>
      </footer>
    </div>
  </div>
</template>

<script lang="ts">
import { ref, defineComponent } from "vue";
import axios from "axios";
import { baseUri } from "../config";
import OfficeLogin from "./OfficeLogin.vue";
import currentUser from "../services/UserService";


export default defineComponent({
  name: "SignIn",
  components: {
    OfficeLogin,
  },
  setup: () => {
    const count = ref(0);
    return { count };
  },
  data() {
    return {
      email: "",
      password: "",
      errorMessages: [],
    };
  },
  watch: {
    email(value) {
      this.validateEmail();
    },
    password(value) {
      this.validatePassword();
    },
  },
  methods: {
    // CHECK IF EMAIL IS WELL FORMATTED
    validateEmail() {
      let regexEmail = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
      if (!regexEmail.test(this.email))
        this.errorMessages["email"] = "Invalid Email Address.";
      else this.errorMessages["email"] = "";
    },

    // CHECK IF PASSWORD IS LONG ENOUGH
    validatePassword() {
      if (this.password.length < 6)
        this.errorMessages["password"] = "Too short password.";
      else this.errorMessages["password"] = "";
    },

    // CHECK IF INPUTS ARE FILLED
    checkInputs() {
      if (!this.email || !this.password) return false;
      if (this.errorMessages["email"] || this.errorMessages["password"])
        return false;
      return true;
    },

    // CALL SERVER FOR SIGN-IN
    async signIn() {
      console.log(this.email + " wants to sign-in");
      try {
        const ret = await axios.post(baseUri + "/auth/sign-in", {
          email: this.email,
          password: this.password,
        });
        console.log(ret);
        currentUser.connect(ret.data.token);
        this.$router.push("/dashboard");
      } catch (error) {
        console.log(error);
        if (error.response.status == 409)
          this.errorMessages["request"] = "Invalid credentials.";
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