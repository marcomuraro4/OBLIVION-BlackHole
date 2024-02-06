<template>
  <div class="component-wrapper flex-container-column">
    <div class="title-container">
      <h2>Temperature</h2>
    </div>
    <div class="knob-wrapper flex-container-column">
      <RoundSlider
          v-model="temperature"
          min="0.01"
          max="500"
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
      <label>{{ temperature }}</label>
    </div>
  </div>
</template>

<script src="./TemperatureControl.js"></script>

<style src="./TemperatureControl.css"></style>
