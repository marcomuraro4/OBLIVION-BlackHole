import ControlPanel from '../ControlPanel/ControlPanel.vue'

import OSC from 'osc-js'

const client = new OSC.WebsocketClientPlugin({
    host: '127.0.0.1',
    port: 8081
});

const osc = new OSC({ plugin: client });

await osc.open();

const message = new OSC.Message('/OSCinit', 'Black Hole App');
osc.on('open', () => {
    osc.send(message);
});

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
        sendOSCMessage(update) {
            osc.open();
            const message = new OSC.Message('/OSCTest', update.label, update.value);
            osc.on('open', () => {
                osc.send(message);
                console.log('Message Sent!');
            });
        },
        updateState(update) {
            this.engineState[update.label].value = update.value;
            console.log(this.engineState[update.label].name + " updated: ", update.value);
            this.sendOSCMessage(update);
        }
    }
}