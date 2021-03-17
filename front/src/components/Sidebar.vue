<template>
  <nav class="flex fixed w-full items-center justify-between px-6 h-16 bg-white text-gray-700 border-b border-gray-200 z-10">
    <div class="flex items-center">
      <button class="mr-2" aria-label="Open Menu" @click="drawer">
        <span class="iconify" data-icon="mdi:menu" data-inline="false"></span>
      </button>
      <h3 class="my-4 text-2xl">ChadArea</h3>
    </div>
    <div class="flex items-center">
      <div class="hidden md:block md:flex md:justify-between md:bg-transparent">
      <!-- On peut foutre des boutons sur la navbar ici -->
      </div>
    </div>
    <transition
      enter-class="opacity-0"
      enter-active-class="ease-out transition-medium"
      enter-to-class="opacity-100"
      leave-class="opacity-100"
      leave-active-class="ease-out transition-medium"
      leave-to-class="opacity-0">
      <div @keydown.esc="isOpen = false" v-show="isOpen" class="z-10 fixed inset-0 transition-opacity">
        <div @click="isOpen = false" class="absolute inset-0 bg-black opacity-50" tabindex="0"></div>
      </div>
    </transition>
    <aside class="transform top-0 left-0 w-64 bg-white fixed h-full overflow-auto ease-in-out transition-all duration-300 z-30" :class="isOpen ? 'translate-x-0' : '-translate-x-full'">
      <span @click="isOpen = false" class="flex w-full items-center p-4 border-b">
        <img src="../assets/AREALOGO.png" alt="Logo" class="h-auto mx-auto object-fit:contain" />
      </span>
      <router-link to="/" v-slot="{ href, route, navigate, isActive, isExactActive }">
        <span @click="isOpen = false" class="flex items-center p-4 hover:bg-indigo-500 hover:text-white">
          <span class="mr-2">
            <span class="iconify" data-icon="mdi:home" data-inline="false"></span>
          </span>
          <span>Home</span>
        </span>
      </router-link>
      <template v-if="isConnected()">
        <router-link to="/dashboard" v-slot="{ href, route, navigate, isActive, isExactActive }">
          <span @click="isOpen = false" class="flex items-center p-4 hover:bg-indigo-500 hover:text-white">
            <span class="mr-2">
              <span class="iconify" data-icon="mdi:view-dashboard" data-inline="false"></span>
            </span>
            <span>Dashboard</span>
          </span>
        </router-link>
      </template>
      <template v-if="isConnected()">
        <router-link to="/users" v-slot="{ href, route, navigate, isActive, isExactActive }">
          <span @click="isOpen = false" class="flex items-center p-4 hover:bg-indigo-500 hover:text-white">
            <span class="mr-2">
              <span class="iconify" data-icon="fa-solid:user-friends" data-inline="false"></span>
            </span>
            <span>Users</span>
          </span>
        </router-link>
      </template>
      <router-link to="/about" v-slot="{ href, route, navigate, isActive, isExactActive }">
        <span @click="isOpen = false" class="flex items-center p-4 hover:bg-indigo-500 hover:text-white">
          <span class="mr-2">
            <span class="iconify" data-icon="mdi:information" data-inline="false"></span>
          </span>
          <span>About</span>
        </span>
      </router-link>
      <router-link to="/aboutjson" v-slot="{ href, route, navigate, isActive, isExactActive }">
        <span @click="isOpen = false" class="flex items-center p-4 hover:bg-indigo-500 hover:text-white">
          <span class="mr-2">
              <span class="iconify" data-icon="mdi:code-json" data-inline="false"></span>
          </span>
          <span>about.json</span>
        </span>
      </router-link>
      <div class="fixed bottom-0 w-full">
        <a href="/client.apk" target="_blank">
          <span @click="isOpen = false" class="flex items-center p-4 hover:bg-indigo-500 hover:text-white">
            <span class="mr-2">
              <span class="iconify" data-icon="icomoon-free:android" data-inline="false"></span>
            </span>
            <span>Get ChadArea on Android</span>
          </span>
        </a>
        <template v-if="isConnected() == false">
          <router-link to="/signin" v-slot="{ href, route, navigate, isActive, isExactActive }">
            <span @click="isOpen = false" class="flex items-center p-4 bg-blue-500 text-white hover:bg-blue-600">
              <span class="mr-2">
                <span class="iconify" data-icon="mdi:account" data-inline="false"></span>
              </span>
              <span>Sign In</span>
            </span>
          </router-link>
          <router-link to="/signup" v-slot="{ href, route, navigate, isActive, isExactActive }">
            <span @click="isOpen = false" class="flex items-center p-4 bg-blue-500 text-white hover:bg-blue-600">
              <span class="mr-2">
                <span class="iconify" data-icon="mdi:account-multiple-plus" data-inline="false"></span>
              </span>
              <span>Sign Up</span>
            </span>
          </router-link>
        </template>
        <template v-else>
          <router-link to="/profile" v-slot="{ href, route, navigate, isActive, isExactActive }">
            <span @click="isOpen = false" class="flex items-center p-4 bg-blue-500 text-white hover:bg-blue-600">
              <span class="mr-2">
                <span class="iconify" data-icon="mdi:account-circle" data-inline="false"></span>
              </span>
              <span>Profile</span>
            </span>
          </router-link>
          <router-link to="/signout" v-slot="{ href, route, navigate, isActive, isExactActive }">
            <span @click="isOpen = false" class="flex items-center p-4 bg-red-500 text-white hover:bg-red-600">
              <span class="mr-2">
                <span class="iconify" data-icon="mdi:logout-variant" data-inline="false"></span>
              </span>
              <span>Sign Out</span>
            </span>
          </router-link>
        </template>
      </div>
    </aside>
  </nav>
</template>

<script lang="ts">
import { ref, defineComponent } from 'vue'
import currentUser from '../services/UserService'
import axios from "axios";

export default defineComponent({
  name: 'Sidebar',
  data() {
    return {
      isOpen: false
    };
  },
  methods: {
    drawer() {
      this.isOpen = !this.isOpen;
    },
    isConnected() {
      return currentUser.isConnected();
    },
  },
  watch: {
    isOpen: {
      immediate: true,
      handler(isOpen) {
        if (process.client) {
          if (isOpen) document.body.style.setProperty("overflow", "hidden");
          else document.body.style.removeProperty("overflow");
        }
      }
    }
  },
  mounted() {
    document.addEventListener("keydown", e => { // Juste la meilleure feature enfaite. Tu peux faire échap pour virer la sidebar
      if (e.keyCode == 27 && this.isOpen) this.isOpen = false;
    });
  }
});
</script>

<style>
.iconify {
  width: 2em;
  height: 2em;
}
</style>