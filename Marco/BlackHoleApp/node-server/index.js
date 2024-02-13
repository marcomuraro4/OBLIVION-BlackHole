const osc = require("osc"),
    WebSocket = require("ws");

const getIPAddresses = function () {
    const os = require("os"),
        interfaces = os.networkInterfaces();
    let ipAddresses = [];

    for (let deviceName in interfaces) {
        let addresses = interfaces[deviceName];

        for (let i = 0; i < addresses.length; i++) {
            let addressInfo = addresses[i];

            if (addressInfo.family === "IPv4" && !addressInfo.internal) {
                ipAddresses.push(addressInfo.address);
            }
        }
    }

    return ipAddresses;
};

const udpPort = new osc.UDPPort({
    localAddress: "0.0.0.0",
    localPort: 7400,
    remoteAddress: "127.0.0.1",
    remotePort: 57121
});

udpPort.on("ready", () => {
    const ipAddresses = getIPAddresses();
    console.log("Listening for OSC over UDP.");
    ipAddresses.forEach(function (address) {
        console.log("Host:", address + ", Port:", udpPort.options.localPort);
    });
    console.log("Broadcasting OSC over UDP to", udpPort.options.remoteAddress + ", Port:", udpPort.options.remotePort);
});

udpPort.open();

const wss = new WebSocket.Server({
    port: 8081
});

wss.on("connection", (socket) => {
    console.log("A Web Socket connection has been established!");
    const socketPort = new osc.WebSocketPort({
        socket: socket
    });

    const relay = new osc.Relay(udpPort, socketPort, {
        raw: true
    });
});
