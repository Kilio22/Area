<template>
  <div class="flex flex-wrap bg-gray-100">
    <div class="my-4 px-4 w-full overflow-hidden">
      <div class="flex items-center justify-center h-screen">
        <body class="flex items-center justify-center">
          <div class="container -mt-96">
            <table
              class="w-full flex flex-row flex-no-wrap sm:bg-white rounded-lg overflow-hidden sm:shadow-lg"
            >
              <thead class="text-white">
                <tr
                  class="bg-teal-400 flex flex-col flex-no wrap sm:table-row rounded-l-lg sm:rounded-none"
                >
                  <th class="p-3 text-center bg-gray-500">Name</th>
                  <th class="p-3 text-center bg-gray-500">Email</th>
                  <th class="p-3 text-center bg-gray-500">Actions</th>
                  <th class="bg-gray-500"></th>
                </tr>
              </thead>
              <tbody
                v-if="!users[0]"
                class="flex-1 sm:flex-none"
              >
                <tr
                  class="flex flex-col flex-no wrap sm:table-row mb-2 sm:mb-0"
                >
                  <td class="border-grey-light border hover:bg-gray-100 px-10">
                    No user
                  </td>
                  <td class="border-grey-light border hover:bg-gray-100 px-10">
                    No user
                  </td>
                  <td
                    class="border-grey-light border hover:bg-gray-100 p-6 text-red-500 hover:text-red-600 cursor-pointer"
                  >
                    No user
                  </td>
                </tr>
              </tbody>
              <tbody
                v-for="(user, index) in users"
                :key="user"
                class="flex-1 sm:flex-none"
              >
                <tr
                  class="flex flex-col flex-no wrap sm:table-row mb-2 sm:mb-0"
                >
                  <td class="border-grey-light border hover:bg-gray-100 px-10">
                    {{ user.displayName }}
                  </td>
                  <td class="border-grey-light border hover:bg-gray-100 px-10">
                    {{ user.email }}
                  </td>
                  <td
                    class="border-grey-light border hover:bg-gray-100 p-6 text-red-500 hover:text-red-600 cursor-pointer"
                    v-on:click="deleteUser(user.id, index)"
                  >
                    Delete
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </body>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { ref, defineComponent } from "vue";
import axios from "axios";
import { baseUri } from "../config";
import currentUser from "../services/UserService";

export default defineComponent({
  name: "Users",

  setup: () => {
    const count = ref(0);
    return { count };
  },

  data() {
    return {
      users: [],
    };
  },

  methods: {
    async deleteUser(id, index) {
      console.log(index)
      if (index == 0)
        this.users.shift();
      else
        this.users.splice(index)
      try {
        const ret = await axios.delete(baseUri + `/users/${id}`, {
          headers: {
            authorization: `Bearer ${currentUser.jwt}`,
          },
        });
      } catch (error) {
        console.log(error);
        if (error.response.status == 500) console.log("500: Server Error");
      }
    },
  },

  async mounted() {
    try {
      const ret = await axios.get(baseUri + "/users", {
        headers: {
          authorization: `Bearer ${currentUser.jwt}`,
        },
      });

      this.users = ret.data;
    } catch (error) {
      console.log(error);
      if (error.response.status == 500) console.log("500: Server Error");
    }
  },
});
</script>

<style>
html,
body {
  height: 100%;
}

@media (min-width: 640px) {
  table {
    display: inline-table !important;
  }

  thead tr:not(:first-child) {
    display: none;
  }
}

td:not(:last-child) {
  border-bottom: 0;
}

th:not(:last-child) {
  border-bottom: 2px solid rgba(0, 0, 0, 0.1);
}
</style>