<template>
  <div class="component-wrapper flex-container-column">
    <div class="title-container">
      <h2>Mass</h2>
    </div>
    <div class="knob-wrapper flex-container-column">
      <RoundSlider
        v-model="mass"
        min="0.01"
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
      <label>{{ mass }}</label>
    </div>
  </div>
</template>

<script src="./MassControl.js"></script>

<style src="./MassControl.css"></style>
