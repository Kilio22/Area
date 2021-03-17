<template>
  <div>
    <!-- Hero Section -->
    <div class="relative overflow-hidden">
      <div class="root">
        <!-- <pre class="overflow-x-scroll">
            {{ aboutString }}
        </pre> -->
        <vue-json-pretty :path="'res'" :data="aboutString"> </vue-json-pretty>
      </div>
      <div class="space-bottom">
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { ref, defineComponent } from "vue";
import { baseUri } from "../config";
import axios from "axios";
import VueJsonPretty from 'vue-json-pretty';
import 'vue-json-pretty/lib/styles.css';

export default defineComponent({
  name: "AboutJson",
  components: {
      VueJsonPretty,
  },
  data() {
    return {
      aboutString: "Getting about.json from the server...",
    }
  },
  async mounted() {
    try {
      const ret = await axios.get(baseUri + "/about.json", {});
      this.aboutString = ret.data;
    } catch (error) {
      this.aboutString = "Couldn't get about.json from the server. Please try again later.";
      console.log(error);
      if (error.response.status == 500) {
        console.log("500: Server Error");
          this.aboutString = "500: Internal Server Error";
      } else {
        this.aboutString = "Unknown error. Please refer to the logs.";
      }
    }
    this.$forceUpdate();
  }
});
</script>

<style scoped>
.space-bottom {
  margin-top: 65px;
}
.root {
  margin-top: 120px;
  text-align: left;
  border: 5px dotted #CFD1C9;
  border-radius: 27px;
  width: 75%;
  background: rgba(207,209,201,0.28);
  display: inline-block;
  padding-left: 25px;
  padding: 25px;
}
</style>