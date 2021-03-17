<template>
  <div class="min-h-screen p-6 bg-gray-100 lg:justify-center">
    <div class="md:-space-y-96 sm:-space-y-48">
      <!-- EDIT PROFILE CARDS -->
      <EditInfos v-if="!officeLogin" ref="editInfos"></EditInfos>
      <EditPassword v-if="!officeLogin"></EditPassword>

      <!-- SIGNED IN W. OFFICE-->
      <div
        v-if="officeLogin"
        class="flex items-center justify-center min-h-screen p-4 -mt-24"
      >
        <div
          class="mx-auto bg-white rounded-md shadow-md xl:w-3/12 xl:-mt-96 -mt-32"
        >
          <h3 class="my-4 xl:mt-10 text-lg font-semibold text-gray-600">
            You are signed in with your Microsoft account:
          </h3>
          <h3 class="my-4 text-lg font-semibold text-blue-500">
            {{ email }}
          </h3>
        </div>
      </div>

      <!-- SERVICES CARDS GRID-->
      <div class="flex flex-wrap -mx-3 overflow-shown">
        <!-- TWITTER CARD -->
        <div class="my-3 w-full overflow-hidden xl:-mt-16">
          <div class="mx-auto bg-white rounded-md shadow-lg md:w-1/4">
            <div
              v-on:click="twitterRegistration"
              class="p-5 bg-blue-500 cursor-pointer"
              :class="{ 'cursor-not-allowed': toggles['twitter'] }"
            >
              <div
                class="flex flex-wrap -mx-3 overflow-hidden space-x-6 items-center"
              >
                <img src="../assets/servicesIcons/twitter.png" />
                <span class="text-white font-semibold text-xl">Twitter</span>
                <div class="switch">
                  <div
                    class="w-16 h-10 bg-gray-300 rounded-full p-1 duration-300 ease-in-out"
                    :class="{ 'bg-blue-400': toggles['twitter'] }"
                  >
                    <div
                      class="bg-white w-8 h-8 rounded-full shadow-md transform duration-300 ease-in-out"
                      :class="{ 'translate-x-6': toggles['twitter'] }"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <!-- GITHUB CARD -->
        <div class="my-3 w-full overflow-hidden -mt-0.5">
          <div class="mx-auto bg-white rounded-md shadow-lg md:w-1/4">
            <div
              v-on:click="githubRegistration"
              class="p-5 bg-gray-700 cursor-pointer"
              :class="{ 'cursor-not-allowed': toggles['github'] }"
            >
              <div
                class="flex flex-wrap -mx-3 overflow-hidden space-x-6 items-center"
              >
                <img src="../assets/servicesIcons/github.png" />
                <span class="text-white font-semibold text-xl">Github</span>
                <div class="switch">
                  <div
                    class="w-16 h-10 bg-gray-300 rounded-full p-1 duration-300 ease-in-out"
                    :class="{ 'bg-gray-600': toggles['github'] }"
                  >
                    <div
                      class="bg-white w-8 h-8 rounded-full shadow-md transform duration-300 ease-in-out"
                      :class="{ 'translate-x-6': toggles['github'] }"
                    ></div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- YOUTUBE CARD -->
          <div class="my-3 w-full overflow-hidden">
            <div class="mx-auto bg-white rounded-md shadow-lg md:w-1/4">
              <div
                v-on:click="youtubeRegistration"
                class="p-5 bg-red-600 cursor-pointer"
                :class="{ 'cursor-not-allowed': toggles['youtube'] }"
              >
                <div
                  class="flex flex-wrap -mx-3 overflow-hidden space-x-6 items-center"
                >
                  <img src="../assets/servicesIcons/youtube.png" />
                  <span class="text-white font-semibold text-xl">Youtube</span>
                  <div class="switch">
                    <div
                      class="w-16 h-10 bg-gray-300 rounded-full p-1 duration-300 ease-in-out"
                      :class="{ 'bg-red-500': toggles['youtube'] }"
                    >
                      <div
                        class="bg-white w-8 h-8 rounded-full shadow-md transform duration-300 ease-in-out"
                        :class="{ 'translate-x-6': toggles['youtube'] }"
                      ></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- OUTLOOK CARD -->
          <div class="my-3 w-full overflow-hidden">
            <div class="mx-auto bg-white rounded-md shadow-lg md:w-1/4">
              <div
                v-on:click="outlookRegistration"
                class="p-5 bg-blue-700 cursor-pointer"
                :class="{ 'cursor-not-allowed': toggles['outlook'] }"
              >
                <div
                  class="flex flex-wrap -mx-3 overflow-hidden space-x-6 items-center"
                >
                  <img src="../assets/servicesIcons/outlook.png" />
                  <span class="text-white font-semibold text-xl">Outlook</span>
                  <div class="switch">
                    <div
                      class="w-16 h-10 bg-gray-300 rounded-full p-1 duration-300 ease-in-out"
                      :class="{ 'bg-blue-600': toggles['outlook'] }"
                    >
                      <div
                        class="bg-white w-8 h-8 rounded-full shadow-md transform duration-300 ease-in-out"
                        :class="{ 'translate-x-6': toggles['outlook'] }"
                      ></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <img v-if="konami" class="absolute w-128 h-64" src="../assets/bonk.jpg" />
    </div>
    <footer>
      <h6 class="text-sm font-medium -mb-4">© 2021 Chad Corporation</h6>
    </footer>
  </div>
</template>

<script lang="ts">
import { ref, defineComponent } from "vue";
import axios from "axios";
import { baseUri } from "../config";
import EditInfos from "./cards/EditInfos.vue";
import EditPassword from "./cards/EditPassword.vue";
import currentUser from "../services/UserService";

export default defineComponent({
  name: "Profile",
  components: {
    EditInfos,
    EditPassword,
  },

  setup: () => {
    const count = ref(0);
    return { count };
  },

  data() {
    return {
      toggles: [],
      username: "",
      email: "",
      officeLogin: false,
      konami: false,
    };
  },

  methods: {
    checkregisteredServices(ret) {
      this.toggles["twitter"] = false;
      this.toggles["github"] = false;
      this.toggles["youtube"] = false;
      this.toggles["outlook"] = false;
      if (ret.data.services && ret.data.services.length) {
        console.log(ret.data.services);
        for (const service of ret.data.services) {
          if (service.localeCompare("twitter") == 0)
            this.toggles["twitter"] = true;
          if (service.localeCompare("github") == 0)
            this.toggles["github"] = true;
          if (service.localeCompare("google") == 0)
            this.toggles["youtube"] = true;
          if (service.localeCompare("microsoft") == 0)
            this.toggles["outlook"] = true;
        }
      }
    },

    async twitterRegistration() {
      if (this.toggles["twitter"] == false) {
        console.log("Click twitter");
        try {
          const ret = await axios.get(baseUri + "/connect/twitter", {
            headers: {
              authorization: `Bearer ${currentUser.jwt}`,
            },
          });
          console.log(ret);
          window.location.href = ret.data.url;
        } catch (error) {
          console.log(error);
        }
      }
    },

    async githubRegistration() {
      if (this.toggles["github"] == false) {
        console.log("Registration to Github service");
        try {
          const ret = await axios.get(baseUri + "/connect/github", {
            headers: {
              authorization: `Bearer ${currentUser.jwt}`,
            },
          });
          console.log(ret);
          window.location.href = ret.data.url;
        } catch (error) {
          console.log(error);
        }
      }
    },

    async discordRegistration() {
      if (this.toggles["discord"] == false) {
        console.log("Registration to Discord service");
        try {
          const ret = await axios.get(baseUri + "/connect/discord", {
            headers: {
              authorization: `Bearer ${currentUser.jwt}`,
            },
          });
          console.log(ret);
          window.location.href = ret.data.url;
        } catch (error) {
          console.log(error);
        }
      }
    },

    async youtubeRegistration() {
      if (this.toggles["youtube"] == false) {
        console.log("Registration to Youtube service");
        try {
          const ret = await axios.get(baseUri + "/connect/google", {
            headers: {
              authorization: `Bearer ${currentUser.jwt}`,
            },
          });
          console.log(ret);
          window.location.href = ret.data.url;
        } catch (error) {
          console.log(error);
        }
      }
    },

    async outlookRegistration() {
      if (this.toggles["outlook"] == false) {
        console.log("Registration to Outlook service");
        try {
          const ret = await axios.get(baseUri + "/connect/microsoft", {
            headers: {
              authorization: `Bearer ${currentUser.jwt}`,
            },
          });
          console.log(ret);
          window.location.href = ret.data.url;
        } catch (error) {
          console.log(error);
        }
      }
    },
  },

  async mounted() {
    try {
      const ret = await axios.get(baseUri + "/profile", {
        headers: {
          authorization: `Bearer ${currentUser.jwt}`,
        },
      });
      this.$refs.editInfos.username = ret.data.displayName;
      this.$refs.editInfos.email = ret.data.email;
      this.email = ret.data.email;
      this.officeLogin = ret.data.isMicrosoftAuthed;

      this.checkregisteredServices(ret);
    } catch (error) {
      console.log(error);
      if (error.response.status == 500) console.log("500: Server Error");
    }
    let cursor = 0;
    const KONAMI_CODE = [38, 38, 40, 40, 37, 39, 37, 39, 66, 65];
    document.addEventListener("keydown", (e) => {
      cursor = e.keyCode == KONAMI_CODE[cursor] ? cursor + 1 : 0;
      if (cursor == KONAMI_CODE.length) this.konami = true;
    });
  },
});
</script>

<style scoped>
a {
  color: #42b983;
}
.switch {
  position: absolute;
  right: 40%;
}
</style>