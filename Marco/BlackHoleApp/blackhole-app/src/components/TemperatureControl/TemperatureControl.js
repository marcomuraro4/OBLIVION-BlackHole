import RoundSlider from "vue-three-round-slider";

export default {
    name: 'Temperature',
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
            temperature: this.engineState.temperature
        }
    },
    watch: {
        temperature() {
            console.log('Temperature changed:', this.temperature);
            this.$emit("stateChange", {name: 'temperature', value: this.temperature})
        }
    }
}