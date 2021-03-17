<template>
    <div class="relative overflow-y-scroll h-full">
      <header class="root bg-white shadow">
        <div class="max-w-7xl mx-auto py-6 px-4 sm:px-6 lg:px-8">
          <h1 class="mytitle text-3xl leading-tight text-gray-900 font-light">
            Dashboard
          </h1>
        </div>
      </header>
      <main>
        <div class="max-w-7xl mx-auto py-6 sm:px-6 lg:px-8 text-left">
          <div class="px-4 py-6 sm:px-0">
            <div class="rounded-lg h-96 flax space-y-5">
              <template v-if="alert">
                <template v-if="alertStyle == 'ok'">
                  <div class="relative py-3 pl-4 pr-10 leading-normal text-green-700 bg-green-100 rounded-lg" role="alert">
                    <p> <span class="font-bold">Nice!</span> Whatever you did worked.</p>
                    <span class="absolute inset-y-0 right-0 flex items-center mr-4">
                      <svg v-on:click="disableAlert" class="w-4 h-4 fill-current" role="button" viewBox="0 0 20 20"><path d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" fill-rule="evenodd"></path></svg>
                    </span>
                  </div>
                </template>
                <template v-if="alertStyle == 'ko'">
                  <div class="relative py-3 pl-4 pr-10 leading-normal text-red-700 bg-red-100 rounded-lg" role="alert">
                    <p> <span class="font-bold">Something went wrong!</span> Please try again later.</p>
                    <span class="absolute inset-y-0 right-0 flex items-center mr-4">
                      <svg v-on:click="disableAlert" class="w-4 h-4 fill-current" role="button" viewBox="0 0 20 20"><path d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd" fill-rule="evenodd"></path></svg>
                    </span>
                  </div>
                </template>
              </template>
              <div>
                <p class="mt-2 text-sm">Welcome to your dashboard.</p>
                <p class="mt-2 text-sm">You can manage your ChadArea Automations here.</p>
              </div>
              <button type="button" v-on:click="openModal" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-green-600 text-base font-medium text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 sm:ml-3 sm:text-sm">
                Add a new Automation!
              </button>
              <!-- ALL AREAS HERE -->
              <div class="flex flex-col">
                <div class="overflow-y-auto sm:-mx-6 lg:-mx-8">
                  <div class="py-2 align-middle min-w-full sm:px-6 lg:px-8">
                    <div class="shadow border-b border-gray-200 sm:rounded-lg">
                      <table class="min-w-full divide-y divide-gray-200">
                        <thead class="bg-gray-50">
                          <tr>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Action
                            </th>
                            <th scope="col" class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                              Reaction
                            </th>
                            <th scope="col" class="relative px-6 py-3">
                              <span class="sr-only">Edit</span>
                            </th>
                            <th scope="col" class="relative px-6 py-3">
                              <span class="sr-only">Delete</span>
                            </th>
                          </tr>
                        </thead>
                        <tbody class="bg-white divide-y divide-gray-200">
                          <template v-for="anArea in allAreas" class="overflow-y-scroll">
                            <tr>
                              <td class="px-6 py-4 whitespace-nowrap has-tooltip">
                                <div class="relative mx-2 tooltip">
                                  <div class="transform -translate-y-full bg-black text-white text-xs rounded py-1 px-4 right-0 bottom-full">
                                    <template v-for="param in anArea.action.params[0].list">
                                      <template v-if="param.check != 'None'">
                                        {{ titleCaseWord(param.requestValue) }} : {{ param.value }} <br>
                                      </template>
                                      <template v-else>
                                        No parameters needed.
                                      </template>
                                    </template>
                                    <svg class="absolute text-black h-2 left-0 ml-3 top-full" x="0px" y="0px" viewBox="0 0 255 255" xml:space="preserve"><polygon class="fill-current" points="0,0 127.5,127.5 255,0"/></svg>
                                  </div>
                                </div>
                                <div class="ml-4">
                                  <div class="text-sm font-medium text-gray-900">
                                    {{ titleCaseWord(anArea.action.service) }}
                                  </div>
                                  <div class="text-sm text-gray-500">
                                    {{ titleCaseWord(anArea.action.params[0].description) }}
                                  </div>
                                </div>
                              </td>
                              <td class="px-6 py-4 whitespace-nowrap has-tooltip">
                                <div class="relative mx-2 tooltip">
                                  <div class="transform -translate-y-full bg-black text-white text-xs rounded py-1 px-4 right-0 bottom-full">
                                    <template v-for="param in anArea.reaction.params[0].list">
                                      {{ titleCaseWord(param.requestValue) }} : {{ param.value }} <br>
                                    </template>
                                    <svg class="absolute text-black h-2 left-0 ml-3 top-full" x="0px" y="0px" viewBox="0 0 255 255" xml:space="preserve"><polygon class="fill-current" points="0,0 127.5,127.5 255,0"/></svg>
                                  </div>
                                </div>
                                <div class="text-sm text-gray-900">
                                  {{ titleCaseWord(anArea.reaction.service) }}
                                </div>
                                <div class="text-sm text-gray-500">
                                    {{ titleCaseWord(anArea.reaction.params[0].description) }}
                                </div>
                              </td>
                              <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                <button v-on:click="openEdit(anArea)" class="text-green-600 hover:text-green-900">Edit</button>
                              </td>
                              <td class="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                                <button v-on:click="deleteArea(anArea.id)" class="text-red-600 hover:text-red-900">Delete</button>
                              </td>
                            </tr>
                          </template>
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </div>
              <!-- MODAL HERE -->
              <template v-if="modalState">
                <div>
                  <div class="fixed z-10 inset-0">
                    <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0">
                      <div class="fixed inset-0 transition-opacity" aria-hidden="true">
                        <div class="absolute inset-0 bg-gray-500 opacity-75"></div>
                      </div>
                      <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>
                      <div class="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full" role="dialog" aria-modal="true" aria-labelledby="modal-headline">
                        <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4">
                          <div class="">
                            <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                              <div class="mt-2 space-y-4">
                                <template v-if="editMode">
                                  <h3 class="text-xl leading-6 font-medium text-gray-900" id="modal-headline">
                                    Edit an Automation :
                                  </h3>
                                </template>
                                <template v-else>
                                  <h3 class="text-xl leading-6 font-medium text-gray-900" id="modal-headline">
                                    Add an Automation :
                                  </h3>
                                </template>
                                <span
                                  class="text-sm font-semibold text-red-500"
                                  >{{ errorMsg }}</span
                                >
                                <h3 class="text-md leading-6 font-medium text-gray-600" id="modal-headline"> Action </h3>
                                <div class="relative text-gray-600">
                                  <svg class="w-2 h-2 absolute top-0 right-0 m-4 pointer-events-none" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 412 232"><path d="M206 171.144L42.678 7.822c-9.763-9.763-25.592-9.763-35.355 0-9.763 9.764-9.763 25.592 0 35.355l181 181c4.88 4.882 11.279 7.323 17.677 7.323s12.796-2.441 17.678-7.322l181-181c9.763-9.764 9.763-25.592 0-35.355-9.763-9.763-25.592-9.763-35.355 0L206 171.144z" fill="#648299" fill-rule="nonzero"/></svg>
                                  <select v-model="actionServiceString" class="border-2 rounded-full text-gray-600 h-10 pl-5 pr-10 bg-white hover:border-gray-400 focus:outline-none appearance-none w-full">
                                    <option disabled selected>Choose a service</option>
                                    <template v-for="aService in availableActionServices">
                                      <option> {{ aService }} </option>
                                    </template>
                                  </select>
                                </div>
                                <!-- Action Action -->
                                <template v-if="action != undefined">
                                  <div class="relative text-gray-600">
                                    <svg class="w-2 h-2 absolute top-0 right-0 m-4 pointer-events-none" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 412 232"><path d="M206 171.144L42.678 7.822c-9.763-9.763-25.592-9.763-35.355 0-9.763 9.764-9.763 25.592 0 35.355l181 181c4.88 4.882 11.279 7.323 17.677 7.323s12.796-2.441 17.678-7.322l181-181c9.763-9.764 9.763-25.592 0-35.355-9.763-9.763-25.592-9.763-35.355 0L206 171.144z" fill="#648299" fill-rule="nonzero"/></svg>
                                    <select v-model="actionParamsString" class="border-2 rounded-full text-gray-600 h-10 pl-5 pr-10 bg-white hover:border-gray-400 focus:outline-none appearance-none w-full">
                                      <option disabled selected>Choose an action</option>
                                      <template v-for="aParam in action.params">
                                        <option> {{ aParam.description }} </option>
                                      </template>
                                    </select>
                                  </div>
                                </template>
                                <template v-if="actionParams != undefined">
                                  <template v-for="aParam in actionParams">
                                    <template v-if="aParam.type != 'None'">
                                      <div class="relative text-gray-600">
                                        <span class="text-sm font-semibold text-red-500">
                                          {{ aParam.error }}
                                        </span>
                                        <input v-model="aParam.value" :placeholder="aParam.placeholder" class="bg-white h-10 px-5 pr-10 rounded-full border-2 text-sm focus:outline-none hover:border-gray-400 w-full">
                                      </div>
                                    </template>
                                  </template>
                                </template>
                                <!-- Reaction Service -->
                                <h3 class="text-md leading-6 font-medium text-gray-600" id="modal-headline"> Reaction </h3>
                                <div class="relative text-gray-600">
                                  <svg class="w-2 h-2 absolute top-0 right-0 m-4 pointer-events-none" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 412 232"><path d="M206 171.144L42.678 7.822c-9.763-9.763-25.592-9.763-35.355 0-9.763 9.764-9.763 25.592 0 35.355l181 181c4.88 4.882 11.279 7.323 17.677 7.323s12.796-2.441 17.678-7.322l181-181c9.763-9.764 9.763-25.592 0-35.355-9.763-9.763-25.592-9.763-35.355 0L206 171.144z" fill="#648299" fill-rule="nonzero"/></svg>
                                  <select v-model="reactionServiceString" class="border-2 rounded-full text-gray-600 h-10 pl-5 pr-10 bg-white hover:border-gray-400 focus:outline-none appearance-none w-full">
                                    <option disabled selected>Choose a service</option>
                                    <template v-for="aService in availableReactionServices">
                                      <option> {{ aService }} </option>
                                    </template>
                                  </select>
                                </div>
                                <!-- Reaction Reaction -->
                                <template v-if="reaction != undefined">
                                  <template v-if="reactionServiceString == 'Discord'">
                                    <p class="mt-2 text-sm"><a target="_blank" href="https://discord.com/api/oauth2/authorize?client_id=<YOUR_DISCORD_CLIENT_ID>&permissions=2048&scope=bot"> Invite AreaChad's discord bot to your server now! </a></p>
                                  </template>
                                  <div class="relative text-gray-600">
                                    <svg class="w-2 h-2 absolute top-0 right-0 m-4 pointer-events-none" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 412 232"><path d="M206 171.144L42.678 7.822c-9.763-9.763-25.592-9.763-35.355 0-9.763 9.764-9.763 25.592 0 35.355l181 181c4.88 4.882 11.279 7.323 17.677 7.323s12.796-2.441 17.678-7.322l181-181c9.763-9.764 9.763-25.592 0-35.355-9.763-9.763-25.592-9.763-35.355 0L206 171.144z" fill="#648299" fill-rule="nonzero"/></svg>
                                    <select v-model="reactionParamsString" class="border-2 rounded-full text-gray-600 h-10 pl-5 pr-10 bg-white hover:border-gray-400 focus:outline-none appearance-none w-full">
                                      <option disabled selected>Choose a reaction</option>
                                      <template v-for="aParam in reaction.params">
                                        <option> {{ aParam.description }} </option>
                                      </template>
                                    </select>
                                  </div>
                                </template>
                                <template v-if="reactionParams != undefined">
                                  <template v-for="aParam in reactionParams">
                                    <template v-if="aParam.type != 'None'">
                                      <div class="relative text-gray-600">
                                        <span class="text-sm font-semibold text-red-500">
                                          {{ aParam.error }}
                                        </span>
                                        <input v-model="aParam.value" :placeholder="aParam.placeholder" class="bg-white h-10 px-5 pr-10 rounded-full border-2 text-sm focus:outline-none hover:border-gray-400 w-full">
                                      </div>
                                    </template>
                                  </template>
                                </template>
                              </div>
                            </div>
                          </div>
                        </div>
                        <div class="bg-gray-50 px-4 py-3 sm:px-6 sm:flex sm:flex-row-reverse">
                          <button v-on:click="sendData" type="button" class="w-full inline-flex justify-center rounded-md border border-transparent shadow-sm px-4 py-2 bg-green-600 text-base font-medium text-white hover:bg-green-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-green-500 sm:ml-3 sm:w-auto sm:text-sm">
                            Add
                          </button>
                          <button v-on:click="closeModal"  type="button" class="mt-3 w-full inline-flex justify-center rounded-md border border-gray-300 shadow-sm px-4 py-2 bg-white text-base font-medium text-gray-700 hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 sm:mt-0 sm:ml-3 sm:w-auto sm:text-sm">
                            Cancel
                          </button>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </template>
            </div>
          </div>
        </div>
        <div style="height: 300px">
        </div>
      </main>
    </div>
</template>

<script lang="ts">
import { ref, defineComponent } from 'vue'
import {Param, ParamList, Selectable, Area} from '../services/AutomationStorage'
import areaManager from '../services/AreaService'
import data from "../services/AutomationStorage";

interface IDashboard {
  modalState: boolean;
  editMode: boolean;
  action: Selectable;
  actionParams: ParamList;
  actionParamsString: string;
  actionIndex: number;
  reaction: Selectable;
  reactionParams: ParamList;
  reactionIndex: number;
  reactionParamsString: string;
  baseActionServices: Array<string>;
  baseReactionServices: Array<string>;
  availableActionServices: Array<string>;
  availableReactionServices: Array<string>;
  actionServiceString: string;
  reactionServiceString: string;
  data: AutomationStorage;
  error: boolean;
  errorMsg: string;
  selectedArea: Area;
  allAreas: Array<Area>;
  alert: boolean;
  alertStyle: string;
}

export default defineComponent({
  name: 'Dashboard',
  data(): IDashboard {
    return {
      modalState: false,
      editMode: false,
      action: undefined,
      actionParams: undefined,
      actionParamsString: "Choose an action",
      actionIndex: undefined,
      reaction: undefined,
      reactionParams: undefined,
      reactionIndex: undefined,
      reactionParamsString: "Choose a reaction",
      baseActionServices: ["Microsoft", "Google", "Github", "Timer"],
      baseReactionServices: ["Twitter", "Microsoft", "Github", "Discord"],
      availableActionServices: [],
      availableReactionServices: [],
      actionServiceString: "Choose a service",
      reactionServiceString: "Choose a service",
      data: data,
      areaManager: areaManager,
      errorMsg: "",
      selectedArea: undefined,
      allAreas: undefined,
      alert: false,
      alertStyle: "ok",
    }
  },
  watch: {
    reactionServiceString: function (val) {
      if (this.editMode)
        return;
      for (var i: number = 0; i < this.data.reactions.length; i++) {
        if (this.data.reactions[i].service == val) {
          this.reaction = this.data.reactions[i];
        }
      }
    },
    reactionParamsString: function (val) {
      if (this.reaction == null || this.reaction == undefined || this.reaction.params == null || this.reaction.params == undefined || this.editMode)
        return;
      for (var i: number = 0; i < this.reaction.params.length; i++) {
        if (this.reaction.params[i].description == val) {
          this.reactionParams = this.reaction.params[i].list;
          this.reactionIndex = i;
        }
      }
    },
    actionServiceString: function (val) {
      if (this.editMode)
        return;
      for (var i: number = 0; i < this.data.actions.length; i++) {
        if (this.data.actions[i].service == val) {
          this.action = this.data.actions[i];
        }
      }
    },
    actionParamsString: function (val) {
      if (this.action == null || this.action == undefined || this.action.params == null || this.action.params == undefined || this.editMode)
        return;
      for (var i: number = 0; i < this.action.params.length; i++) {
        if (this.action.params[i].description == val) {
          this.actionParams = this.action.params[i].list;
          this.actionIndex = i;
        }
      }
    },
  },
  methods: {
    editModeUpdateForm() {
      for (var i: number = 0; i < this.reaction.params.length; i++) {
        if (this.reaction.params[i].description == this.reactionParamsString) {
          this.reactionParams = this.reaction.params[i].list;
          this.reactionIndex = i;
        }
      }
      for (var i: number = 0; i < this.action.params.length; i++) {
        if (this.action.params[i].description == this.actionParamsString) {
          this.actionParams = this.action.params[i].list;
          this.actionIndex = i;
        }
      }
    },
    disableAlert() {
      this.alert = false;
    },
    displayAlert(style: string) {
      this.alert = true;
      this.alertStyle = style;
      setTimeout(() => this.disableAlert(), 10000);
    },
    updateErrors() {
      this.errorMsg = "";
      if (this.reactionIndex == undefined)
        this.errorMsg = "Please pick a reaction before submitting."
      for (var i:number = 0; this.reactionParams && i < this.reactionParams.length; i++) {
        var tmp: Param = new Param(this.reactionParams[i].type, this.reactionParams[i].check, this.reactionParams[i].placeholder, this.reactionParams[i].requestValue);
        tmp.value = this.reactionParams[i].value;
        if (!tmp.validateValue())
          this.errorMsg = "Please input correct values.";
      }
      if (this.actionIndex == undefined)
        this.errorMsg = "Please pick an action before submitting."
      for (var i:number = 0; this.actionParams && i < this.actionParams.length; i++) {
        var tmp: Param = new Param(this.actionParams[i].type, this.actionParams[i].check, this.actionParams[i].placeholder, this.actionParams[i].requestValue);
        tmp.value = this.actionParams[i].value;
        if (!tmp.validateValue())
          this.errorMsg = "Please input correct values.";
      }
    },
    titleCaseWord(word: string) {
      if (!word) return word;
        return word[0].toUpperCase() + word.substr(1).toLowerCase();
    },
    async loadData() {
      var areas = await this.areaManager.getAreaList();
      var services = await this.areaManager.getUserServices();

      if (areas == null) {
        this.allAreas = [];
      } else {
        this.allAreas = areas;
      }
      this.availableActionServices = new Array<string>();
      this.availableReactionServices = new Array<string>();
      if (services != null) {
        for (var i:number = 0; i < services.length; i++) {
          if (services[i] == "timer" || services[i] == "discord")
            continue;
          for (var j:number = 0; j < this.baseActionServices.length; j++) {
            if (this.titleCaseWord(services[i]) == this.baseActionServices[j]) {
              this.availableActionServices.push(this.titleCaseWord(services[i]));
              break;
            }
          }
          for (var j:number = 0; j < this.baseReactionServices.length; j++) {
            if (this.titleCaseWord(services[i]) == this.baseReactionServices[j]) {
              this.availableReactionServices.push(this.titleCaseWord(services[i]));
              break;
            }
          }
        }
      }
      this.availableActionServices.push("Timer");
      this.availableReactionServices.push("Discord");
      this.$forceUpdate();
    },
    deleteArea(id:number) {
      this.areaManager.deleteArea(id);
      this.loadData();
    },
    openEdit(area: Area) {
      this.editMode = true;
      this.selectedArea = area;
      this.openModal();
    },
    openModal() {
      if (this.editMode == true) {
        if (this.selectedArea == undefined || this.selectedArea == null) {
          this.displayAlert("ko");
          return;
        } else {
          this.actionServiceString = this.titleCaseWord(this.selectedArea.action.service);
          this.actionParamsString = this.selectedArea.action.params[0].description;
          this.reactionServiceString = this.titleCaseWord(this.selectedArea.reaction.service);
          this.reactionParamsString = this.selectedArea.reaction.params[0].description;
          this.action = this.selectedArea.action;
          this.reaction = this.selectedArea.reaction;
          this.actionParams = this.selectedArea.action.params[0].list;
          this.reactionParams = this.selectedArea.reaction.params[0].list;
          this.editModeUpdateForm();
          this.$forceUpdate();
        }
      } else {
        this.action = undefined;
        this.actionParams = undefined;
        this.reaction = undefined;
        this.reactionParams = undefined;
        this.actionParamsString = "Choose an action";
        this.reactionParamsString = "Choose a reaction";
        this.actionServiceString = "Choose a service";
        this.reactionServiceString = "Choose a service";
        this.actionIndex = undefined;
        this.reactionIndex = undefined;
      }
      this.modalState = true;
    },
    closeModal() {
      this.modalState = false;
      this.editMode = false;
      this.errorMsg = "";
      this.data.clearAllValues();
    },
    async sendData() {
      this.updateErrors();
      if (this.errorMsg != "")
        return;
      if ((await this.areaManager.sendArea(this)) != "OK") {
        this.displayAlert("ko");
      } else {
        this.displayAlert("ok");
      }
      this.closeModal();
    }
  },
  async mounted() {
    this.loadData()
    window.setInterval(() => {
      this.loadData()
    }, 5000)
    document.addEventListener("keydown", e => {
      if (e.keyCode == 27 && this.modalState) this.modalState = false;
    });
  }
})
</script>

<style scoped>
.root {
  margin-top : 65px;
}

.mytitle {
  text-align : left;
}

.spacetop {
  margin-top: 55px;
}

.tooltip{
  visibility: hidden;
  position: absolute;
}

.has-tooltip:hover .tooltip {
  visibility: visible;
  z-index: 100;
}
</style>