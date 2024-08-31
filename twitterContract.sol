// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;
contract tweetContract {
    struct Tweet{
        string content;
        address user_address;
        uint timeStamp;
    }
    mapping(address => Tweet[]) public tweet;
    Tweet[] public tweets;
    mapping(address => Message[]) public message;
    mapping(address => mapping(address => bool)) public following;
    mapping (address => mapping(address => bool)) public access;
    uint public currTweetId = 0;
    struct Message{
        address to_user;
        string content;
        uint timeStamp;
    }
    function postTweet(string memory _content) public {
        tweet[msg.sender].push(Tweet({
            content: _content,
            user_address: msg.sender,
            timeStamp: block.timestamp
        }));
        tweets[currTweetId] = Tweet({
            content: _content,
            user_address: msg.sender,
            timeStamp: block.timestamp
        });
        currTweetId++;
    }

    function postTweet(string memory _content, address for_user) public {
        require(access[for_user][msg.sender],"You are not authorized to post tweet on the current address's behalf");
        tweet[for_user].push(Tweet({
            content: _content,
            user_address: msg.sender,
            timeStamp: block.timestamp
        }));
        tweets[currTweetId] = Tweet({
            content: _content,
            user_address: msg.sender,
            timeStamp: block.timestamp
        });
        currTweetId++;
    }

    function sendMessage(string memory _content,address rec_address) public {
        message[msg.sender].push(Message({
            content: _content,
            to_user: rec_address,
            timeStamp: block.timestamp
        }));
    }

    function follow(address to_follow) public {
        following[msg.sender][to_follow] = true;
    }

    function giveAccess(address to_access) public {
        access[msg.sender][to_access] = true;
    }

    function revokeAccess(address to_revoke) public {
        access[msg.sender][to_revoke] = false;
    }

    function seeLatestTweets(uint _count) public view returns(Tweet[] memory){
        if(_count > tweets.length) {
            _count = tweets.length;
        }
        Tweet[] memory latestTweets = new Tweet[](_count);
        for (uint i = 0; i < _count; i++) {
        latestTweets[i] = tweets[tweets.length - _count + i];
        }
        return latestTweets;
    }

    function seeLatestTweetsOfUser(uint _count) public view returns(Tweet[] memory) {
        Tweet[] memory userTweets = tweet[msg.sender];
        if(_count > userTweets.length) {
            _count = userTweets.length;
        }
        Tweet[] memory latestTweetsOfUser = new Tweet[](_count);
        for (uint i = 0; i < _count; i++) {
        latestTweetsOfUser[i] = userTweets[userTweets.length - _count + i];
        }
        return latestTweetsOfUser;
    }   
}

