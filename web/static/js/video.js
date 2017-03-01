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
    let msgInput = document.getElementById("msg-input");
    let postButton = document.getElementById("msg-submit");
    let vidChannel = socket.channel("videos:" + videoId);

    // handle client-side messaging
    postButton.addEventListener("click", e => {
      let payload = {body: msgInput.value, at: Player.getCurrentTime()};
      vidChannel.push("new_annotation", payload)
                .receive("error", e => console.log("Error: ", e));
      msgInput.value = ""
    });

    vidChannel.on("new_annotation", (resp) => {
      this.renderAnnotation(msgContainer, resp);
    });

    // join the vidChannel
    vidChannel.join()
      .receive("ok", resp => console.log("joined the video channel ", resp))
      .receive("error", reason => console.log("join failed ", reason))

    // handle vidChannel ping messages
    vidChannel.on("ping", ({count}) => {
      console.log("What a ping, haha ", count)
    })
  },

  renderAnnotation(msgContainer, {user, body, at}) {
    // append annotation to msgContainer
  }
}

export default Video
