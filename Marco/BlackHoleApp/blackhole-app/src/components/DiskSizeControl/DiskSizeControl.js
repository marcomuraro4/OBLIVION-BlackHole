import RoundSlider from "vue-three-round-slider";

export default {
    name: 'DiskSizeControl',
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
            diskSize: this.engineState.diskSize
        }
    },
    watch: {
        diskSize() {
            console.log('Disk Size changed:', this.diskSize);
            this.$emit("stateChanged", {name: 'DiskSize', value: this.diskSize})
        }
    }
}