<template>
  <div class="component-wrapper flex-container-column">
    <div class="knob-wrapper flex-container-column">
      <RoundSlider
          v-model="rotationSpeed"
          min="1"
          max="100"
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
      <label>{{ rotationSpeed }}</label>
    </div>
    <div class="title-container">
      <h2>Rotation Speed</h2>
    </div>
  </div>
</template>

<script src="./RotationSpeedControl.js"></script>

<style src="./RotationSpeedControl.css"></style>
