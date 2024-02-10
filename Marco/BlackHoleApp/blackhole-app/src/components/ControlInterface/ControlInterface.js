import ControlPanel from '../ControlPanel/ControlPanel.vue'

//import axios from 'axios'

import OSC from 'osc-js'

const options = {
    host: '127.0.0.1',
    port: 57120
};

const plugin = new OSC.WebsocketClientPlugin(options);
const osc = new OSC({ plugin: plugin });
osc.open();

//console.log(osc);

export default {
    name: 'ControlInterface',
    components: {
        ControlPanel
    },
    data() {
        return {
            title: 'OBLIVION',
            engineState: {
                mass: {
                    name: 'Mass',
                    label: 'mass',
                    value: 1,
                    min: 0.01,
                    max: 100,
                    display: 'up'
                },
                temperature: {
                    name: 'Temperature',
                    label: 'temperature',
                    value: 200,
                    min: 0.01,
                    max: 500,
                    display: 'up'
                },
                diskSize: {
                    name: 'Disk Size',
                    label: 'diskSize',
                    value: 1,
                    min: 0.01,
                    max: 10,
                    display: 'down'
                },
                rotationSpeed: {
                    name: 'Rotation Speed',
                    label: 'rotationSpeed',
                    value: 1,
                    min: 0.01,
                    max: 10,
                    display: 'down'
                }
            }
        }
    },
    methods: {
        /*sendData(update) {
            axios
                .put(
                    'http://localhost:30010/remote/preset/BlackHolePreset/property/' + this.engineState[update.label].name + ' (M_BlackHole_Inst)',
                    {
                        "PropertyValue": update.value,
                        "GenerateTransaction": true
                    }
                    )
                .then(() => console.log("PUT Request"));
        },*/
        sendOSCMessage(update) {
            const message = new OSC.Message('/OSCTest', update.value);
            osc.send(message);
            console.log("OSC Address: " + message.address + ", Argument: " + update.value);
        },
        updateState(update) {
            this.engineState[update.label].value = update.value;
            console.log(this.engineState[update.label].name + " updated: ", update.value);
            //this.sendData(update);
            this.sendOSCMessage(update);
        }
    },
    mounted() {
        /*axios
            .get('http://localhost:30010/remote/preset/BlackHolePreset/property/DiskSize (M_BlackHole_Inst)')
            .then(() => this.engineState.diskSize.value = 200);*/
    }
}