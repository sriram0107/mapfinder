let locationWidgets = [];
const GANACHE = 'http://127.0.0.1:7545';
const HOST_ADDRESS = '0xB300ca99B6904f48C3873FC6e3781E77b32C4AfD';
var web3;
const ABI = "";
const ADDRESS = "";
var contract;
var user_acc;

const createDisplayWidget = () => {

}

const displayMyLocations = async () => {
    try {
        const coords = await contract.methods.read().getMyLocations(user_acc);
        // make multiple markers
        var map = new ol.Map({
                target: 'map',
                layers: [
                    new ol.layer.Tile({
                        source: new ol.source.OSM()
                    })
                ],
                view: new ol.View({
                    center: ol.proj.fromLonLat([coords[0]/10000, coords[1]/10000]),
                    zoom: 4
                })
            });
    } catch (err) {
        console.log("Cannot get the location");
    }
}

const displayLocation = async (ID) => {
    try {
        const coords = await contract.methods.read().getLocation(ID);
        var map = new ol.Map({
                target: 'map',
                layers: [
                    new ol.layer.Tile({
                        source: new ol.source.OSM()
                    })
                ],
                view: new ol.View({
                    center: ol.proj.fromLonLat([coords[0]/10000, coords[1]/10000]),
                    zoom: 4
                })
            });
    } catch (err) {
        console.log("Cannot get the location");
    }
}

$(document).ready(() => {
    console.log("executimg function")
    if(typeof web3 !== 'undefined') {
        web3 = new Web3(web3.currentProvider);  
    } else {
        web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
    }

    // Check the connection
    if(!web3.isConnected()) {
        console.error("Not connected");
    }

    contract = new web3.eth.Contract(ABI, ADDRESS);
    user_acc = web3.currentProvider.selectedAddress;
    await contract.methods.read().addLocation(3145, 101683, "https://en.wikipedia.org/wiki/Kuala_Lumpur#/media/File:Moonrise_over_kuala_lumpur.jpg", 100);
    //console.log("default loc added")
    // load all widgets from blockchain
})

$("widget").click(() => {
    // user wants to buy widget

    // let user pay
    // add widget to user's record on blockchain
    displayLocation();
})
