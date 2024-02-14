# OBLIVION
## Interactive Black Hole Visualization and Artistic Sonorization

Oblivion is a an interactive artistic installation which simulates the visual appearance of a black hole. The simulation parameters can be controlled through a dedicated web application and the visual scene is enriched by a soundscape modulated by these parameters.
The user can navigate inside the scene by moving a spaceship with the aid of a controller (or simply with mouse and keyboard).

## How to install

[Windows UE5 executable](https://drive.google.com/file/d/1Z8Ytm-VBDR1TcNSAJueQVP0fjGEL2X5B/view?usp=sharing)

The visual part is realized inside Unreal Engine 5, the auditory part in SuperCollider and the web interface is a vue application running on Node.js.
Here are the instructions on how to set up all the three components:

- Unreal Engine: the simulation can be run directly by launching the appropriate executable for your system. Otherwise, you can package the project yourself as follows, if you have UE5 installed:
    - Put the black hole shader file `ShaderCode/Blackhole.usf` inside the UE5 program folder at `/Engine/Shaders/Private/BlackHole`
    - Open the project inside the `UnrealProject` folder
    - Inside the UE5 editor, click on the **Platforms** button, go to the item corresponding to your system, select the **Shipping** option and click on **Package project**
- Web App: once the BlackHoleApp directory has been opened within an appropriate code editor such as [Visual Studio Code](https://code.visualstudio.com/) or [WebStorm](https://www.jetbrains.com/webstorm/), the following steps should be taken:
  - Open a new terminal tab, move to **blackhole-app** directory and run `npm install` to install all the dependencies needed (keep this tab open)
  - Open another terminal tab, move to **node-server** directory and run `npm install` (keep it open as well)
  - Now, in **node-server** directory, run `node .` to boot the node server 
  - Eventually, in **blackhole-app** directory, run `npm run serve` to serve the Vue App in the browser
- SuperCollider: once the SuperCollider file "Universe_SoundScape.scd" is opened, the auditory scene can be simply started by executing the entire code (ctrl+enter).

## How to use

...here we describe interface and commands for spaceship...
...Put image of controller...


## General Architecture

The communication between the three components is realized through the OSC protocol. When the user changes a parameter value in the web application, this sends an OSC message with the updated value to an OSC server that runs continuously in the UE5 application.
The UE5 also acts as an OSC client, by sending OSC messages each frame to SuperCollider. These messages contain the full status of the simulation, that includes both the parameter values and the spaceship distance from the black hole.
These values are used to modulate the sound produced by SuperCollider.


### Web App Implementation

The web interface was implemented by means of [Vue.js](https://vuejs.org/) framework. In particular, the web application was developed using the [Vue CLI](https://cli.vuejs.org/), which is the standard tooling baseline for Vue ecosystem. 

<p align="center">
  <img width="800" height="auto" alt="Vue App Interface" src="/Assets/Images/VueAppInterface.png">
</p>

...explanation goes on...

<p align="center">
  <img width="800" height="auto" alt="Vue App Architecture" src="/Assets/BlockDiagrams/VueAppArchitecture.png">
</p>

...explanation goes on...

The OSC communication between the Web App and Unreal Engine was implemented through a Node WebSocket Server running at localhost on port 8081, acting as a bridge between the two applications. The Vue app creates a WebSocket Client instance sending messages to the Node Server listening to OSC messages and broadcasting them over UDP to the receiver. The endpoint could run on the same machine or on a remote one. 
To enable the communication between the Vue app and Unreal Engine running on separate machines, go to **index.js** in **node-server** directory and set the correct remote IP address and port (lines 27 and 28 respectively).

Node Server and bridging were implemented through [osc.js](https://github.com/colinbdclark/osc.js) library (by Colin Clark), whereas the OSC Client was created and set up using [osc-js](https://github.com/adzialocha/osc-js) library.

### Graphic Simulation Implementation

The black hole is implemented in UE5 with a custom shader written in HLSL (High Level Shader Language). The user is positioned in the inside of a sphere, whose internal surface is covered with a space sky texture.
The shader, to color each pixel of the scene, utilizes the ray marching technique: it takes a series of small steps in the view direction corresponding to that pixel and check the scene for intersection with objects.
The black hole singularity is assumed to be at the center of the scene (and at the center of the coordinate system) and it's rendered simply as a black sphere.

#### Gravitational Lensing

Supermassive objects in space cause light rays around them to follow curved paths, creating a visual effect known as gravitational lensing. Computing these paths exactly would require integrating sets of differential equations known as geodesics, which is computationally intensive. Instead, we use a simplified model which is able to replicate the visual effect very closely: we compute a gravity force (depending on the distance from the singularity) which is applied on the marching view direction, distorting it in its path.


#### Accretion Disk

To render the accretion disk, we first check if the view path crosses the accretion disk region. This is modeled as an anular region around the black hole singularity, which is surrounded by a fog layer with a certain thickness.
When inside this region, we sample the color of the scene appropriately.
The sampling process works as follows:
- we compute the fog density, which increases towards the center of the disk with a certain function
- we sample a texture to obtain the color of the fog
- we compute the light energy reaching that point (using an inverse square law depending on the distance)
- we sample a texture to obtain the color and density of the accretion disk
- we use a volumetric rendering approach to determine the amount of light absorbed and the one actually reaching the point
- finally the contribution from the disk and the fog color is summed together


##### Disk Rotation

To obtain a realistic rotation effect, the disk should rotate faster close to the event horizon and slower farther away (in particular, it decreases with the cube of the distance). The effect can be obtained by applying a rotation matrix to the UV coordinates when sampling the texture. In pratice, the speed cannot vary continuously with the distance or we will have strange artifacts. Therefore we must divide the disk in multiple discrete bands of constant speed.
To avoid the presence of visible seams between these bands, we add additional shifted bands and then interpolate the results obtained from sampling the texture with the two different sets of bands.


#### Color and Doppler Effect

The disk is colored according to the temperature and the frequency shift (doppler effect) caused by the motion of the disk with respect to the observer. In practice, we use a UV texture which represents a black body radiation and returns a color depending on the U coordinate (frequency shift) and the V coordinate (temperature). The temperature decreases with the distance from the event horizon, while the frequency of light is increased (blueshift) if the disk is moving towards us and decreased (redshift) if moving away.


### SuperCollider Implementation

The entire auditory scene is implemented using SuperCollider. The OSC communication protocol makes it communicating with Unreal Engine 5.
The soundscape concept is based on early sci-fi movies music. The main goal is to emulate sci-fi music in a generative/random fashion while maintaining a certain grade of control on the algorithm. Both harmonic and inharmonic sounds are employed to reach an unreal yet “pleasant” and characteristic sound setting. The aim of this algorithm is to enlighten the vastity of the universe and the immense power of a black hole.

#### Synthesis techniques and FX
Different kind of synthesis has been employed:
-	Subtractive: to set the main background consisting of filtered sawtooth-like waveforms and impulsive sounds
-	FM: to realize short and modulated sinusoids as well as the noisy "particle motion" effect
-	Wavetable: to spread short grapples of ringing sounds derived from the actual sample of a triangle
-	Digital waveguide: to generate a "gust of wind" effect

The sounds coming from different synthesizers are mixed together and then processed by a common reverb effect, which also provides companding and limiting functionalities.

#### Synthesis parameters and user interaction


Fundamental frequencies of the main background sounds are picked up from a restricted set of possible values (to make the result pleasant from a musical standpoint) while all the other parameters (such as envelopes, vibrato, detuning, …) are randomly generated within a range of pre-established values. All the sounds are generated regularly in time with a minimum grade of randomness.

TO BE CONTINUED...
