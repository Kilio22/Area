<template>
  <div>
    <!-- Hero Section -->
    <div class="relative overflow-hidden">
      <div class="max-w-7xl mx-auto">
        <div class="z-10 pb-8 sm:pb-16 md:pb-20 lg:max-w-2xl lg:w-full lg:pb-28 xl:pb-32">
          <div class="pt-6 px-4 sm:px-6 lg:px-8"></div>
          <main class="mt-10 mx-auto max-w-7xl px-4 sm:mt-12 sm:px-6 md:mt-16 lg:mt-20 lg:px-8 xl:mt-28">
            <div class="sm:text-center lg:text-left">
              <h1 class="text-4xl font-extrabold text-gray-900 sm:text-5xl md:text-6xl">
                <span class="xl:inline">Connect your apps and </span>
                <span class="text-indigo-600 xl:inline"> automate workflows</span>
              </h1>
              <p class="mt-3 text-base text-gray-500 sm:mt-5 sm:text-lg sm:max-w-xl sm:mx-auto md:mt-5 md:text-xl lg:mx-0">
                Easy automation for busy people. <br />
                From social media to emails, connect your favourite <br />
                apps so you can save time to do the things you love.
              </p>
              <div class="mt-5 sm:mt-8 sm:flex sm:justify-center lg:justify-start"></div>
            </div>
          </main>
        </div>
      </div>
      <div class="lg:absolute lg:inset-y-0 lg:right-0 lg:w-1/2">
        <img class="h-56 w-full object-cover sm:h-72 md:h-96 lg:w-full lg:h-full" src="../assets/background.jpg" alt=""/>
      </div>
    </div>

  <!-- Get started section -->
  <div class="bg-gray-50">
    <div class="max-w-7xl mx-auto py-12 px-4 sm:px-6 lg:py-16 lg:px-8 lg:flex lg:items-center lg:justify-between">
      <h2 class="text-3xl font-extrabold tracking-tight text-gray-900 sm:text-4xl">
        <span class="block">Ready to dive in?</span>
        <span class="block text-indigo-600">Start using ChadArea for free today.</span>
      </h2>
      <div class="mt-8 flex lg:mt-0 lg:flex-shrink-0">
        <router-link to="/signup" v-slot="{ href, route, navigate, isActive, isExactActive }">
          <div class="inline-flex rounded-md shadow">
            <p class="inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700">
              Sign Up
            </p>
          </div>
        </router-link>
        <router-link to="/signin" v-slot="{ href, route, navigate, isActive, isExactActive }">
          <div class="ml-3 inline-flex rounded-md shadow">
            <p class="inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-indigo-600 bg-white hover:bg-indigo-50">
              Sign In
            </p>
          </div>
        </router-link>
      </div>
    </div>
  </div>

    <!-- Download APK -->
    <div class="bg-gray-50">
      <div class="max-w-7xl py-6 mx-auto px-4 sm:px-6 lg:flex lg:items-center lg:justify-between">
        <h2 class="text-xl font-extrabold tracking-tight text-gray-900 sm:text-2xl">
          <span class="block">Want to try it out on mobile ?</span>
          <span class="block text-indigo-600">Download the APK now and use it natively on your android phone as well!</span>
        </h2>
        <a href="/client.apk" target="_blank" class="inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700">
          Download APK
        </a>
      </div>
    </div>

  <!-- Features Section -->
  <div class="py-12 bg-white">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="lg:text-center">
        <h2
          class="text-base text-indigo-600 font-semibold tracking-wide uppercase"
        >
          Automations
        </h2>
        <p
          class="mt-2 text-3xl leading-8 font-extrabold tracking-tight text-gray-900 sm:text-4xl"
        >
          A better way to use the internet
        </p>
        <p class="mt-4 max-w-2xl text-xl text-gray-500 lg:mx-auto">
          With ChadArea, you can connect your apps and accounts and make the
          things you love more powerful.
        </p>
      </div>
      <div class="mt-10">
        <dl
          class="space-y-10 md:space-y-0 md:grid md:grid-cols-2 md:gap-x-8 md:gap-y-10"
        >
          <div class="flex">
            <div class="flex-shrink-0">
              <div
                class="flex items-center justify-center h-12 w-12 rounded-md bg-indigo-500 text-white"
              >
                <!-- Heroicon name: globe-alt -->
                <svg
                  class="h-6 w-6"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  aria-hidden="true"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"
                  />
                </svg>
              </div>
            </div>
            <div class="ml-4">
              <dt class="text-lg leading-6 font-medium text-gray-900">
                Automate workflows
              </dt>
              <dd class="mt-2 text-base text-gray-500">
                Connect up to 6 services and link 15+ actions & reactions.
              </dd>
            </div>
          </div>
          <div class="flex">
            <div class="flex-shrink-0">
              <div
                class="flex items-center justify-center h-12 w-12 rounded-md bg-indigo-500 text-white"
              >
                <!-- Heroicon name: scale -->
                <svg
                  class="h-6 w-6"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  aria-hidden="true"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M3 6l3 1m0 0l-3 9a5.002 5.002 0 006.001 0M6 7l3 9M6 7l6-2m6 2l3-1m-3 1l-3 9a5.002 5.002 0 006.001 0M18 7l3 9m-3-9l-6-2m0-2v2m0 16V5m0 16H9m3 0h3"
                  />
                </svg>
              </div>
            </div>
            <div class="ml-4">
              <dt class="text-lg leading-6 font-medium text-gray-900">
                It's free
              </dt>
              <dd class="mt-2 text-base text-gray-500">
                It's completely free, no hidden fees!
              </dd>
            </div>
          </div>
          <div class="flex">
            <div class="flex-shrink-0">
              <div
                class="flex items-center justify-center h-12 w-12 rounded-md bg-indigo-500 text-white"
              >
                <!-- Heroicon name: lightning-bolt -->
                <svg
                  class="h-6 w-6"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  aria-hidden="true"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M13 10V3L4 14h7v7l9-11h-7z"
                  />
                </svg>
              </div>
            </div>
            <div class="ml-4">
              <dt class="text-lg leading-6 font-medium text-gray-900">
                Fast and customizable
              </dt>
              <dd class="mt-2 text-base text-gray-500">
                You can customize your integrations easily thanks to our state
                of the art dashboard.
              </dd>
            </div>
          </div>
          <div class="flex">
            <div class="flex-shrink-0">
              <div
                class="flex items-center justify-center h-12 w-12 rounded-md bg-indigo-500 text-white"
              >
                <svg
                  class="h-6 w-6"
                  xmlns="http://www.w3.org/2000/svg"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                  aria-hidden="true"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M7 8h10M7 12h4m1 8l-4-4H5a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v8a2 2 0 01-2 2h-3l-4 4z"
                  />
                </svg>
              </div>
            </div>
            <div class="ml-4">
              <dt class="text-lg leading-6 font-medium text-gray-900">
                Mobile app
              </dt>
              <dd class="mt-2 text-base text-gray-500">
                Customize your automations on the go.
              </dd>
            </div>
          </div>
        </dl>
      </div>
    </div>
    <!-- Testimonials Section -->
    <div class="center linespace md:w-1/2 md:px-4 mt-6 md:mt-0">
      <div
        class="testimonial center p-6 border-2 border-solid flex hover:border-indigo-400 hover:bg-indigo-100 transition-colors duration-300"
      >
        <div
          class="w-16 h-16 md:w-20 md:h-20 rounded-full overflow-hidden mr-4 md:mr-6 flex-shrink-0"
        >
          <img
            src="../assets/avatar.png"
            alt="profile image"
            class="w-full h-full object-cover"
          />
        </div>
        <div>
          <p class="center text-gray-600">
            "It really saves me time and effort. I can send emails directly from
            twitter! It's way faster! Using ChadArea has really changed my
            life."
          </p>
          <div class="text-gray-900 font-bold uppercase mt-6">
            - An anonymous user.
          </div>
          <div class="text-gray-600">(not us)</div>
        </div>
      </div>
    </div>
      <footer>
        <h6 class="text-sm font-medium -mb-8">© 2021 Chad Corporation</h6>
      </footer>
  </div>
  </div>
</template>

<script lang="ts">
import { ref, defineComponent } from "vue";
import axios from "axios";

export default defineComponent({
  name: "Home"
});
</script>

<style scoped>
.testimonial {
  border-radius: 1rem;
}

.linespace {
  margin-top: 65px;
  margin-bottom: 65px;

}

.center {
  width: 100;
  margin-left: auto;
  margin-right: auto;
}

.stickybottom {
  display: block;
  position: sticky;
  bottom: 0px;
}
</style>