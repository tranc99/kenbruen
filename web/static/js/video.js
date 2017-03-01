import Player from "./player";

let Video = {
  init(socket, element){
    if(!element) {
      return;
    }
    let playerId = element.getAttribute("data-player-id");
    let videoId = element.getAttribute("data-id");
    socket.connect();
    Player.init(element.id, playerId, () => {
      this.onReady(videoId, socket);
    });
  },

  onReady(videoId, socket) {
    console.log("player ready!");
    let msgContainer = document.getElementById("msg-container");
    let msgInput = document.getElementById("msg-submit");
    let vidChannel = socket.channel("videos:" + videoId);
    // join the vidChannel
    vidChannel.join()
      .receive("ok", resp => console.log("joined the video channel ", resp))
      .receive("error", reason => console.log("join failed ", reason))

    // handle vidChannel ping messages
    vidChannel.on("ping", ({count}) => {
      console.log("What a ping, haha ", count)
    })
  }
}

export default Video
