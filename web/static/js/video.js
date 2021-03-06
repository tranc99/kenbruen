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

    msgContainer.addEventListener("click", e => {
      e.preventDefault();
      let seconds = e.target.getAttribute("data-seek") || e.target.parentNode.getAttribute("data-seek");
      if(!seconds) { return; }

      Player.seekTo(seconds);
    });

    vidChannel.on("new_annotation", (resp) => {
      vidChannel.params.last_seen_id = resp.id;
      this.renderAnnotation(msgContainer, resp);
    });

    // join the vidChannel
    vidChannel.join()
      .receive("ok", resp =>  {
          console.log("joined the video channel ");
          let ids = resp.annotations.map(ann => ann.id);
          if(ids.length > 0) {
            vidChannel.params.last_seen_id = Math.max(...ids);
          }
          this.scheduleMessages(msgContainer, resp.annotations);
        })
      .receive("error", reason => console.log("join failed ", reason))

    // handle vidChannel ping messages
    vidChannel.on("ping", ({count}) => {
      console.log("What a ping, haha ", count)
    })
  },

  esc(str) {
    let div = document.createElement("div");
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
  },

  renderAnnotation(msgContainer, {user, body, at}) {
    // append annotation to msgContainer
    let template = document.createElement("div");
    template.innerHTML = `
      <a href="#" data-seek="${this.esc(at)}">
        [${this.formatTime(at)}]
        <b>${this.esc(user.username)}</b>: ${this.esc(body)}
      </a>
    `;
    msgContainer.appendChild(template);
    msgContainer.scrollTop = msgContainer.scrollHeight;
  },

  scheduleMessages(msgContainer, annotations) {
    setTimeout(() => {
      let ctime = Player.getCurrentTime()
      let remaining = this.renderAtTime(annotations, ctime, msgContainer)
      this.scheduleMessages(msgContainer, remaining)
    }, 1000)
  },

  renderAtTime(annotations, seconds, msgContainer) {
    return annotations.filter(ann => {
      if (ann.at > seconds) {
        return true;
      } else {
        this.renderAnnotation(msgContainer, ann);
        return false;
      }
    })
  },

  formatTime(at) {
    let date = new Date(null);
    date.setSeconds(at / 1000);
    return date.toISOString().substr(14, 5);
  },
}

export default Video
