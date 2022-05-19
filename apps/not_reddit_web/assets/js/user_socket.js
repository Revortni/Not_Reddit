import { Socket } from "phoenix";

let socket = new Socket("/socket", { params: { token: window.userToken } });
socket.connect();

const createSocket = (topicId)=>{
  let channel = socket.channel(`comments:${topicId}`, {});
  channel
    .join()
    .receive("ok", (resp) => {
      console.log("Joined successfully", renderComments(resp.comments));
    })
    .receive("error", (resp) => {
      console.log("Unable to join", resp);
    });
  
  document.querySelector('#add-comment').addEventListener('click',()=>{
    const content = document.querySelector('#comment-input').value
    channel.push('comment:add', { content: content})
  }) 

}

function renderComments(comments){
  const renderedComments = comments.map((comment)=>{
    return `<li class='collection-item'>${comment.content}</li>`
  })

  document.querySelector('#comment-section').innerHTML = renderedComments.join('')
}

window.createSocket = createSocket
