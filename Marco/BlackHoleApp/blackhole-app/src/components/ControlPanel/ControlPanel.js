import RoundSlider from 'vue-three-round-slider'

export default {
    name: 'ControlPanel',
    components: {
        RoundSlider
    },
    props: {
        controlParam: Object
    },
    data() {
        return {
            roundSlider: {
                min: this.controlParam.min,
                max: this.controlParam.max,
                step: this.controlParam.step,
                radius: 80,
                width: 12,
                startAngle: 315,
                endAngle: 225,
                lineCap: 'round',
                startValue: 0.01,
                showTooltip: false,
                rangeColor: 'white'
            },
            name: this.controlParam.name,
            label: this.controlParam.label,
            value: this.controlParam.value,
            display: this.controlParam.display
        }
    },
    watch: {
        value() {
            console.log(this.name + ' changed:', this.value);
            this.$emit("stateChange", {label: this.label, value: this.value})
        }
    }
}