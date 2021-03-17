import axios from "axios";
import { baseUri } from "../config";
import currentUser from "../services/UserService";
import data from "./AutomationStorage";
import { deepCopy } from "../utils/deepCopy";
import {Area, Param, ParamList, Selectable} from '../services/AutomationStorage'


class AreaManager {

    lastLoggedError: string;

    constructor() {
        this.lastLoggedError = "";
    }

    getLastError(): string {
        return this.lastLoggedError;
    }

    async getUserServices(): Promise<any> {
        if (!currentUser.isConnected() || currentUser.jwt == null || currentUser.jwt == "") {
            this.lastLoggedError = "401 : Unauthorized";
            return "401 : Unauthorized";
        }
        try {
            const ret = await axios.get(baseUri + "/profile", {
                headers: {
                authorization: `Bearer ${currentUser.jwt}`,
                },
            });
            return ret.data.services;
        } catch (error) {
            console.log(error);
            if (error.response.status == 500) {
                console.log("500: Server Error");
                this.lastLoggedError = "500: Internal Server Error";
                return "500: Server Error";
            } else {
                this.lastLoggedError = "Unknown error. Please refer to the logs.";
                return "Unknown error. Please refer to the logs.";
            }
        }
    }

    async getAllAreas(): Promise<any> {
        if (!currentUser.isConnected() || currentUser.jwt == null || currentUser.jwt == "") {
            this.lastLoggedError = "401 : Unauthorized";
            return "401 : Unauthorized";
        }
        try {
            const ret = await axios.get(baseUri + "/areas", {
                headers: {
                authorization: `Bearer ${currentUser.jwt}`,
                },
            });
            return ret.data;
        } catch (error) {
            console.log(error);
            if (error.response.status == 500) {
                console.log("500: Server Error");
                this.lastLoggedError = "500: Internal Server Error";
                return "500: Serveur Error";
            } else {
                this.lastLoggedError = "Unknown error. Please refer to the logs.";
                return "Unknown error. Please refer to the logs.";
            }
        }
    }

    private constructParamsList(area: any, dataStorage: Array<Selectable>): any {
        var list: Array<ParamList> = new Array<ParamList>();

        for (var i:number = 0; i < dataStorage.length; i++) {
            if (dataStorage[i].service.toLowerCase() == area.service) {
                for (var j:number = 0; j < dataStorage[i].params.length; j++) {
                    if (dataStorage[i].params[j].requestValue == area.name) {
                        var tmp:ParamList = deepCopy<ParamList>(dataStorage[i].params[j]);
                        for (var k:number = 0; k < tmp.list.length; k++) {
                            switch (tmp.list[k].requestValue) {
                                case "id":
                                    tmp.list[k].value = area.data.id;
                                    break;
                                case "owner":
                                    tmp.list[k].value = area.data.owner;
                                    break;
                                case "repo":
                                    tmp.list[k].value = area.data.repo;
                                    break;
                                case "hour":
                                    tmp.list[k].value = area.data.hour;
                                    break;
                                case "minute":
                                    tmp.list[k].value = area.data.minute;
                                    break;
                                case "to":
                                    tmp.list[k].value = area.data.to;
                                    break;
                                case "body":
                                    tmp.list[k].value = area.data.body;
                                    break;
                                case "title":
                                    tmp.list[k].value = area.data.title;
                                    break;
                                case "subject":
                                    tmp.list[k].value = area.data.subject;
                                    break;
                                default:
                                    break;
                            }
                            tmp.list[k].error = "";
                        }
                        list.push(tmp);
                    }
                }
            }
        }
        return list;
    }

    async getAreaList(): Promise<any> {
        const areas = await this.getAllAreas();
        var constructedAreas: Array<Area> = new Array<Area>();

        if (!areas || areas.length == 0) {
            return null;
        }
        for (var i:number = 0; i < areas.length; i++) {
            var tmpArea:Area = new Area(
                new Selectable(areas[i].action.service),
                new Selectable(areas[i].reaction.service)
            );
            tmpArea.id = areas[i].id;
            tmpArea.action.params = this.constructParamsList(areas[i].action, data.actions);
            tmpArea.reaction.params = this.constructParamsList(areas[i].reaction, data.reactions);
            constructedAreas.push(tmpArea);
        }
        if (constructedAreas.length == 0)
            return null;
        return constructedAreas;
    }

    constructAreaFromData(action: Selectable, index: number): any {
        var params:ParamList = new ParamList(action.params[index].description);
        params.list = action.params[index].list;
        params.requestValue = action.params[index].requestValue;
        var data = {
            service: action.service.toLowerCase(),
            name: action.params[index].requestValue,
            data: params.getData()
        }

        return data;
    }

    async sendArea(data: any) {
        if (!currentUser.isConnected() || currentUser.jwt == null || currentUser.jwt == "") {
            this.lastLoggedError = "401 : Unauthorized";
            return "401 : Unauthorized";
        }
        try {
            if (data.editMode == true) {
                const ret = await axios.put(baseUri + "/areas/" + data.selectedArea.id, {
                    action: this.constructAreaFromData(data.action, data.actionIndex),
                    reaction: this.constructAreaFromData(data.reaction, data.reactionIndex)
                },
                {
                    headers: {
                        authorization: `Bearer ${currentUser.jwt}`,
                    },
                });
                return "OK";
            } else {
                const ret = await axios.post(baseUri + "/areas", {
                    action: this.constructAreaFromData(data.action, data.actionIndex),
                    reaction: this.constructAreaFromData(data.reaction, data.reactionIndex)
                },
                {
                    headers: {
                        authorization: `Bearer ${currentUser.jwt}`,
                    },
                });
                return "OK";
            }
        } catch (error) {
            console.log(error);
            if (error.response.status == 500) {
                console.log("500: Server Error");
                this.lastLoggedError = "500: Internal Server Error";
                return "500: Server Error";
            } else {
                this.lastLoggedError = "Unknown error. Please refer to the logs.";
                return "Unknown error. Please refer to the logs.";
            }
        }
    }

    async deleteArea(id:number) {
        if (!currentUser.isConnected() || currentUser.jwt == null || currentUser.jwt == "") {
            this.lastLoggedError = "401 : Unauthorized";
            return "401 : Unauthorized";
        }
        try {
            const ret = await axios.delete(baseUri + "/areas/" + id,
            {
                headers: {
                    authorization: `Bearer ${currentUser.jwt}`,
                },
            });
            return ("OK");
        } catch (error) {
            console.log(error);
            if (error.response.status == 500) {
                console.log("500: Server Error");
                this.lastLoggedError = "500: Internal Server Error";
                return "500: Server Error";
            } else {
                this.lastLoggedError = "Unknown error. Please refer to the logs.";
                return "Unknown error. Please refer to the logs.";
            }
        }
    }
}


let areaManager: AreaManager = new AreaManager();

export default areaManager;