var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);

var userList = [];
var allMessages = [];

http.listen(3001, function(){
  console.log('Listening on *:3001');
});

io.on('connection', function(clientSocket){
  console.log('a user connected');

  clientSocket.on('disconnect', function(){
    console.log('user disconnected');

    var clientNickname;
    for (var i=0; i<userList.length; i++) {
      if (userList[i]["id"] == clientSocket.id) {
        userList[i]["isConnected"] = false;
        clientNickname = userList[i]["nickname"];
        break;
      }
    }

    io.emit("userList", userList);
    io.emit("userExitUpdate", clientNickname);
  });


  clientSocket.on("exitUser", function(clientNickname){
    for (var i=0; i<userList.length; i++) {
      if (userList[i]["id"] == clientSocket.id) {
        userList.splice(i, 1);
        break;
      }
    }
    io.emit("userExitUpdate", clientNickname);
  });


  clientSocket.on('chatMessage', function(clientNickname, message){
    var messageInfo = {};
    var currentDateTime = new Date().toLocaleString();

    messageInfo["nickname"] = clientNickname
    messageInfo["message"] = message
    messageInfo["date"] = currentDateTime

    allMessages.push(messageInfo);

    io.emit('newChatMessage', clientNickname, message, currentDateTime);
  });

  clientSocket.on('messageList', function(clientNickname) {
    io.emit("allMessages", allMessages);
  });

  clientSocket.on("connectUser", function(clientNickname) {
      var message = "User " + clientNickname + " was connected.";
      console.log(message);

      var userInfo = {};
      var foundUser = false;
      for (var i=0; i<userList.length; i++) {
        if (userList[i]["nickname"] == clientNickname) {;
          userList[i]["isConnected"] = true
          userList[i]["id"] = clientSocket.id;
          userInfo = userList[i];
          foundUser = true;
          break;
        }
      }

      if (!foundUser) {
        userInfo["id"] = clientSocket.id;
        userInfo["nickname"] = clientNickname;
        userInfo["isConnected"] = true
        userList.push(userInfo);
      }

      io.emit("userList", userList);
      io.emit("userConnectUpdate", userInfo)
  });
});
