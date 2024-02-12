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
                    unrealLabel: 'mass',
                    value: 5,
                    min: 1,
                    max: 20,
                    display: 'up'
                },
                temperature: {
                    name: 'Temperature',
                    label: 'temperature',
                    unrealLabel: 'DiskTemp',
                    value: 1000,
                    min: 1000,
                    max: 10000,
                    display: 'up'
                },
                diskSize: {
                    name: 'Disk Size',
                    label: 'diskSize',
                    unrealLabel: 'DiskSize',
                    value: 200,
                    min: 80,
                    max: 500,
                    display: 'down'
                },
                rotationSpeed: {
                    name: 'Rotation Speed',
                    label: 'rotationSpeed',
                    unrealLabel: 'RotationSpeed',
                    value: 4.5,
                    min: 0,
                    max: 10,
                    display: 'down'
                }
            }
        }
    },
    methods: {
        sendOSCMessage(update) {
            osc.open();
            const message = new OSC.Message('/' + update.unrealLabel, update.value);
            osc.on('open', () => {
                osc.send(message);
                console.log('Message Sent!');
            });
        },
        updateState(update) {
            this.engineState[update.label].value = update.value;
            update.unrealLabel = this.engineState[update.label].unrealLabel;
            console.log(this.engineState[update.label].name + " updated: ", update.value);
            this.sendOSCMessage(update);
        }
    }
}