import MassControl from '../MassControl/MassControl.vue'
import TemperatureControl from "../TemperatureControl/TemperatureControl.vue";
import DiskSizeControl from "../DiskSizeControl/DiskSizeControl.vue";
import RotationSpeedControl from "../RotationSpeedControl/RotationSpeedControl.vue"

import axios from 'axios'

export default {
    name: 'ControlInterface',
    components: {
        MassControl,
        TemperatureControl,
        DiskSizeControl,
        RotationSpeedControl
    },
    data() {
        return {
            title: 'OBLIVION',
            engineState: {
                mass: 1,
                temperature: 200,
                diskSize: 1,
                rotationSpeed: 1
            }
        }
    },
    methods: {
        sendData(update) {
            axios
                .put(
                    'http://localhost:30010/remote/preset/BlackHolePreset/property/' + update.name + ' (M_BlackHole_Inst)',
                    {
                        "PropertyValue": update.value,
                        "GenerateTransaction": true
                    }
                    )
                .then(() => console.log("PUT Request"));
        },
        updateState(update) {
            switch(update.name) {
                case 'mass':
                    this.engineState.mass = update.value;
                    console.log("Mass updated: ", update.value);
                    break;
                case 'temperature':
                    this.engineState.temperature = update.value;
                    console.log("Temperature updated: ", update.value);
                    break;
                case 'Disk Size':
                    this.engineState.diskSize = update.value;
                    console.log("Disk Size updated: ", update.value);
                    this.sendData(update);
                    break;
                case 'rotationSpeed':
                    this.engineState.rotationSpeed = update.value;
                    console.log("Rotation Speed updated: ", update.value);
                    break;
            }
        }
    },
    mounted() {
        axios
            .get('http://localhost:30010/remote/preset/BlackHolePreset/property/DiskSize (M_BlackHole_Inst)')
            .then(() => this.engineState.diskSize = 200);
    }
}