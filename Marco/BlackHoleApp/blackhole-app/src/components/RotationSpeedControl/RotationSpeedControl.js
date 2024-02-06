import RoundSlider from "vue-three-round-slider";

export default {
    name: 'RotationSpeedControl',
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
            rotationSpeed: this.engineState.rotationSpeed
        }
    },
    watch: {
        rotationSpeed() {
            console.log('Rotation Speed changed:', this.rotationSpeed);
            this.$emit("stateChanged", {name: 'rotationSpeed', value: this.diskSize})
        }
    }
}