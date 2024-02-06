<template>
  <div id="interface" class="flex-container-row">
    <div class="outline-bar sidebar"></div>
    <div id="control-panel" class="flex-container-column">
      <div class="controls-wrapper flex-container-row">
        <div class="control-box">
          <MassControl
              :engineState="engineState"
              @stateChange="updateState"
          />
        </div>
        <div class="control-box">
          <TemperatureControl
              :engineState="engineState"
              @stateChange="updateState"
          />
        </div>
      </div>
      <div>
        <h1>{{ title }}</h1>
      </div>
      <div class="controls-wrapper flex-container-row">
        <div class="control-box">
          <DiskSizeControl
              :engineState="engineState"
              @stateChanged="updateState"
          />
        </div>
        <div class="control-box">
          <RotationSpeedControl
              :engineState="engineState"
              @stateChanged="updateState"
          />
        </div>
      </div>
    </div>
    <div class="outline-bar sidebar"></div>
  </div>
</template>

<script src="./ControlInterface.js"></script>

<style src="./ControlInterface.css"></style>