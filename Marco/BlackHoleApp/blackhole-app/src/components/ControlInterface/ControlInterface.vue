<template>
  <div id="interface" class="flex-container-row">
    <div class="outline-bar sidebar"></div>
    <div id="control-panel" class="flex-container-column">
      <div class="controls-wrapper flex-container-row">
        <div class="control-box">
          <ControlPanel
              :controlParam="engineState.mass"
              @stateChange="updateState"
          />
        </div>
        <div class="control-box">
          <ControlPanel
              :controlParam="engineState.temperature"
              @stateChange="updateState"
          />
        </div>
      </div>
      <div>
        <h1>{{ title }}</h1>
      </div>
      <div class="controls-wrapper flex-container-row">
        <div class="control-box">
          <ControlPanel
              :controlParam="engineState.diskSize"
              @stateChange="updateState"
          />
        </div>
        <div class="control-box">
          <ControlPanel
              :controlParam="engineState.rotationSpeed"
              @stateChange="updateState"
          />
        </div>
      </div>
    </div>
    <div class="outline-bar sidebar"></div>
  </div>
</template>

<script src="./ControlInterface.js"></script>

<style src="./ControlInterface.css"></style>