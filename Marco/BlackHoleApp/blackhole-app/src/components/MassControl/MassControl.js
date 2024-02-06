import RoundSlider from 'vue-three-round-slider'

export default {
    name: 'MassControl',
    components: {
        RoundSlider
    },
    props: {
        engineState: Object
    },
    data() {
        return {
            roundSlider: {
                step: 0.01,
                radius: 80,
                width: 12,
                startAngle: 315,
                endAngle: 225,
                lineCap: 'round',
                startValue: 0.01,
                showTooltip: false,
                rangeColor: 'white'
            },
            mass: this.engineState.mass
        }
    },
    watch: {
        mass() {
            console.log('Mass changed:', this.mass);
            this.$emit("stateChange", {name: 'mass', value: this.mass})
        }
    }
}