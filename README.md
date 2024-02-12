# Oblivion
## Interactive Black Hole Visualization and Artistic Sonorization

Oblivion is a an interactive artistic installation which simulates the visual appearance of a black hole. The simulation parameters can be controlled through a dedicated web application and the visual scene is enriched by a soundscape modulated by these parameters.

## How to install

The visual part is realized inside Unreal Engine 5, the auditory part in SuperCollider and the web app runs on Node.js.
Here are the instructions on how to set up all the three components:

- Unreal Engine: the simulation can be run directly by launching the appropriate executable for your system. Otherwise, you can package the project on your system. (details here)
- Web app: The web app can be run by ...
- SuperCollider: ...
- 

## How to use

...here we describe interface and commands for spaceship...


## General Architecture

The communication between the three components is realized through the OSC protocol. When the user changes a parameter value in the web application, this sends an OSC message with the updated value to an OSC server that runs continuously in the UE5 application.
The UE5 also acts as an OSC client, by sending OSC messages each frame to SuperCollider. These messages contain the full status of the simulation, that includes both the parameter values and the spaceship distance from the black hole.
These values are used to modulate the sound produced by SuperCollider.


### Web App Implementation


### Graphic Simulation Implementation


### SuperCollider Implementation

