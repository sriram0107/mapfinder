pragma solidity >=0.4.22 <0.9.0;

contract MapFinder {
    address public owner;
    uint256 public price = 1000;

    struct Location {
        // all coordinates have 4 point fixed decimals
        uint256 ID;
        uint256 xCoord;
        uint256 yCoord;
        string URL;
    }

    Location[] locations;

    struct User {
        uint256[] display;
        uint256[] bought;
    }

    mapping(address => User) userLst;

    constructor() {
        owner = msg.sender;
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
            URL: ""
        });

        return nullLoc;
    }

    function addLocation(
        uint256 xc,
        uint256 yc,
        string memory url
    ) public {
        require(xc > 0);
        require(yc > 0);
        uint256 currSize = locations.length;
        Location memory newloc = Location({
            ID: currSize,
            xCoord: xc,
            yCoord: yc,
            URL: url
        });
        locations.push(newloc);
        userLst[msg.sender].display.push(currSize);
    }

    function buyLocation(uint256 id, address seller) public payable {
        require(msg.sender != seller);
        for (uint256 i = 0; i < userLst[msg.sender].bought.length; i++) {
            require(userLst[msg.sender].bought[i] != id);
        }
        bool found = false;
        for (uint256 i = 0; i < locations.length; i++) {
            if (locations[i] == id) {
                found = true;
            }
        }
        require(found == true);
        payable(seller).transfer(price);
        userLst[msg.sender].bought.push(id);
    }
}
