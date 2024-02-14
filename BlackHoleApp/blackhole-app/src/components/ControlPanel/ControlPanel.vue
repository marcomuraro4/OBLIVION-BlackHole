<template>
  <div class="component-wrapper flex-container-column">
    <div v-if="(display == 'up')" class="title-container">
      <h2>{{ name }}</h2>
    </div>
    <div
        class="flex-container-column"
        :class="(display == 'up') ? 'knob-wrapper' : 'knob-wrapper-down'">
      <RoundSlider
          v-model="value"
          :min="roundSlider.min"
          :max="roundSlider.max"
          :step="roundSlider.step"
          :radius="roundSlider.radius"
          :width="roundSlider.width"
          :startAngle="roundSlider.startAngle"
          :endAngle="roundSlider.endAngle"
          :lineCap="roundSlider.lineCap"
          :startValue="roundSlider.startValue"
          :showTooltip="roundSlider.showTooltip"
          :rangeColor="roundSlider.rangeColor"
      />
      <label>{{ value }}</label>
    </div>
    <div v-if="(display == 'down')" class="title-container">
      <h2>{{ name }}</h2>
    </div>
  </div>
</template>

<script src="./ControlPanel.js"></script>

<style src="./ControlPanel.css"></style>
