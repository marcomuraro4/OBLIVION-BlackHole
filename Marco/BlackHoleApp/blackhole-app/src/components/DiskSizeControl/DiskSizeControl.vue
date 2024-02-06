<template>
  <div class="component-wrapper flex-container-column">
    <div class="knob-wrapper flex-container-column">
      <RoundSlider
          v-model="diskSize"
          min="1"
          max="10"
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
      <label>{{ diskSize }}</label>
    </div>
    <div class="title-container">
      <h2>Disk Size</h2>
    </div>
  </div>
</template>

<script src="./DiskSizeControl.js"></script>

<style src="./DiskSizeControl.css"></style>
