pragma solidity >=0.4.22 <0.9.0;

contract MapFinder {
    address public owner;
    uint256 public priceDefault = 1000;

    struct Location {
        // all coordinates have 4 point fixed decimals
        uint256 ID;
        uint256 xCoord;
        uint256 yCoord;
        string URL;
        uint256 price;
    }

    Location[] locations;

    struct User {
        uint256[] display;
        uint256[] bought;
    }

    mapping(address => User) userLst;

    mapping(uint256 => address) locOwner;

    constructor() {
        owner = msg.sender;
    }

    function getLocations() public view returns (Location[] memory) {
        return locations;
    }

    function getLocation(uint256 id) public view returns (Location memory) {
        require(id > 0);
        // if in user's display loc or bought loc then show
        for (uint256 i = 0; i < userLst[msg.sender].display.length; i++) {
            if (userLst[msg.sender].display[i] == id) {
                return locations[id];
            }
        }

        for (uint256 i = 0; i < userLst[msg.sender].bought.length; i++) {
            if (userLst[msg.sender].bought[i] == id) {
                return locations[id];
            }
        }

        Location memory nullLoc = Location({
            ID: 0,
            xCoord: 0,
            yCoord: 0,
            URL: "",
            price: 0
        });

        //revert("Location does not exist", nullLoc);
        return nullLoc;
    }

    function addUsers(address[] memory users) public {
        for (uint256 i = 0; i < users.length; i++) {
            User memory u;
            userLst[users[i]] = u;
        }
    }

    function addLocation(
        uint256 xc,
        uint256 yc,
        string memory url,
        uint256 price
    ) public {
        require(xc > 0);
        require(yc > 0);
        uint256 currSize = locations.length;
        Location memory newloc = Location({
            ID: currSize,
            xCoord: xc,
            yCoord: yc,
            URL: url,
            price: price
        });
        locOwner[currSize] = msg.sender;
        userLst[msg.sender].display.push(currSize);
        locations.push(newloc);
    }

    function buyLocation(uint256 id) public payable returns (bool) {
        require(msg.sender != locOwner[id]);
        for (uint256 i = 0; i < userLst[msg.sender].bought.length; i++) {
            require(userLst[msg.sender].bought[i] != id);
        }
        require(id >= 0);
        require(id <= locations.length);
        require(msg.value == locations[id].price);

        bool status = payable(locOwner[id]).send(msg.value);
        if (status) {
            userLst[msg.sender].bought.push(id);
        }
        return status;
    }

    function debug1() public view returns (uint256[] memory) {
        return userLst[msg.sender].bought;
    }

    function debug2() public view returns (uint256[] memory) {
        return userLst[msg.sender].display;
    }

    //     function getAll() public view returns (address[] memory){
    //         address[] memory ret = new address[](addressRegistryCount);
    //         for (uint i = 0; i < addressRegistryCount; i++) {
    //             ret[i] = addresses[i];
    //         }
    //         return ret;
    // }

    // function getMyLocations(uint256 id) public view returns (uint256[2][]) {
    //     // if in user's display loc or bought loc then show
    //     uint256[2][] locs = [];
    //     for (uint256 i = 0; i < userLst[msg.sender].bought.length; i++) {
    //         locs[i][0] = userLst[msg.sender].bought[i].xCoord;
    //         locs[i][1] = userLst[msg.sender].bought[i].yCoord;
    //     }
    //     return locs;
    // }
}
