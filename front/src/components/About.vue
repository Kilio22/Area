<template>
  <div class="flex flex-wrap overflow-hidden bg-gray-100">
    <div class="my-4 px-4 w-full overflow-hidden">
      <div class="flex items-center justify-center min-h-screen p-4">
        <!-- PROJECT DESCRIPTION -->
        <div class="mx-auto bg-white rounded-md shadow-md md:w-2/3 xl:-mt-96">
          <h3
            class="relative text-2xl font-semibold text-gray-700 -mt-10 xl:-mt-14"
          >
            Project Overview
          </h3>
          <h3 class="my-4 xl:mt-10 text-lg font-semibold text-gray-700">
            Epitech 3rd year final project (20/01/21 - 07/03/21).
          </h3>
          <h3 class="my-4 text-lg font-semibold text-gray-700">
            This project consists in the creation of a software suite that
            functions similarly to IFTTT / Zapier.
          </h3>
          <h3 class="my-4 text-lg font-semibold text-gray-700">
            You are using the web version of ChadArea, which was developed in
            VueJS & Typescript and uses our server created using NodeJs &
            MongoDb.
          </h3>
          <h3 class="my-4 text-lg font-semibold text-gray-700">
            For more detailed information about the project, please refer to the
            documentation provided in the official Github page of the project.
          </h3>
          <button
            class="bg-gray-700 cursor-pointer py-2 px-4 mb-4 rounded inline-flex items-center"
            v-on:click="goToGithub"
          >
            <img
              src="../assets/servicesIcons/github.png"
              class="h-8 w-8 mr-2"
            />
            <span class="text-white font-semibold text-lg">Github</span>
          </button>
        </div>
      </div>

      <div class="my-4 overflow-hidden -mt-12 xl:-mt-96">
        <h3 class="text-2xl font-semibold text-gray-700 mb-4 xl:mb-24">
          Our Team
        </h3>
        <div class="flex items-center justify-center min-h-screen xl:-mt-32">
          <div
            class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-3 gap-12"
          >
            <!-- NATHAN -->
            <div
              class="flex flex-col items-center justify-center bg-white p-4 shadow-md rounded-lg xl:h-96 xl:w-96"
            >
              <div
                class="inline-flex shadow-lg border border-gray-200 rounded-full overflow-hidden h-40 w-40 xl:h-52 xl:w-52"
              >
                <img
                  src="../assets/team/watermelon.png"
                  alt=""
                  class="h-full w-full"
                />
              </div>
              <h2 class="mt-4 font-bold text-xl">Nathan LECORCHET</h2>
              <h6 class="mt-2 text-sm font-medium">Back Developper</h6>
            </div>
            <!-- GHASSANE -->
            <div
              class="flex flex-col items-center justify-center bg-white p-4 shadow-md rounded-lg xl:h-96 xl:w-96"
            >
              <!-- <h3 class="absolute text-2xl font-semibold text-gray-700 top-24">
              Our Team
            </h3> -->
              <div
                class="inline-flex shadow-lg border border-gray-200 rounded-full overflow-hidden h-40 w-40 xl:h-52 xl:w-52"
              >
                <img
                  src="../assets/team/bubz.png"
                  alt=""
                  class="h-full w-full"
                />
              </div>
              <h2 class="mt-4 font-bold text-xl">Ghassane SEBAÏ</h2>
              <h6 class="mt-2 text-sm font-medium">
                Web developper & Designer
              </h6>
            </div>
            <!-- KILIO -->
            <div
              class="flex flex-col items-center justify-center bg-white p-4 shadow-md rounded-lg xl:h-96 xl:w-96"
            >
              <div
                class="inline-flex shadow-lg border border-gray-200 rounded-full overflow-hidden h-40 w-40 xl:h-52 xl:w-52"
              >
                <img
                  src="../assets/team/sock.png"
                  alt=""
                  class="h-full w-full"
                />
              </div>
              <h2 class="mt-4 font-bold text-xl">Kylian BALAN</h2>
              <h6 class="mt-2 text-sm font-medium">Mobile developper</h6>
            </div>
            <!-- RODO -->
            <div
              class="flex flex-col items-center justify-center bg-white p-4 shadow-md rounded-lg xl:h-96 xl:w-96"
            >
              <div
                class="inline-flex shadow-lg border border-gray-200 rounded-full overflow-hidden h-40 w-40 xl:h-52 xl:w-52"
              >
                <img
                  src="../assets/team/muscle.png"
                  alt=""
                  class="h-full w-full"
                />
              </div>
              <h2 class="mt-4 font-bold text-xl">Rodolphe DUPUIS</h2>
              <h6 class="mt-2 text-sm font-medium">Back Developper</h6>
            </div>
            <!-- ELIOTT -->
            <div
              class="flex flex-col items-center justify-center bg-white p-4 shadow-md rounded-lg xl:h-96 xl:w-96"
            >
              <div
                class="inline-flex shadow-lg border border-gray-200 rounded-full overflow-hidden h-40 w-40 xl:h-52 xl:w-52"
              >
                <img
                  src="../assets/team/ouaf.png"
                  alt=""
                  class="h-full w-full"
                />
              </div>
              <h2 class="mt-4 font-bold text-xl">Eliott PALUEAU</h2>
              <h6 class="mt-2 text-sm font-medium">
                Web developper & Doc redactor
              </h6>
            </div>
            <!-- BEAR -->
            <div
              class="flex flex-col items-center justify-center bg-white p-4 shadow-md rounded-lg xl:h-96 xl:w-96"
            >
              <div
                class="inline-flex shadow-lg border border-gray-200 rounded-full overflow-hidden h-40 w-40 xl:h-52 xl:w-52"
              >
                <img
                  src="../assets/team/bear.png"
                  alt=""
                  class="h-full w-full"
                />
              </div>
              <h2 class="mt-4 font-bold text-xl">CHAD BEAR</h2>
              <h6 class="mt-2 text-sm font-medium">Mascott</h6>
            </div>
          </div>
        </div>
      </div>
      <footer>
        <h6 class="text-sm font-medium">© 2021 Chad Corporation</h6>
      </footer>
    </div>
  </div>
</template>

<script lang="ts">
import { ref, defineComponent } from "vue";

export default defineComponent({
  name: "About",
  setup: () => {
    const count = ref(0);
    return { count };
  },
  methods: {
    // Redirect to github repo page
    goToGithub() {
      window.open(
        "https://github.com/EpitechIT2020/B-YEP-500-REN-5-1-area-eliott.palueau",
        "_blank"
      );
    },
  },
});
</script>

<style scoped>
a {
  color: #42b983;
}
</style>