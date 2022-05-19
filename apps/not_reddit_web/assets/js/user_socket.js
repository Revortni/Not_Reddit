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

  channel.on(`comments:${topicId}:new`, (event)=>{
    renderComment(event.comment)
  })
  
  document.querySelector('#add-comment').addEventListener('click',()=>{
    const content = document.querySelector('#comment-input').value
    channel.push('comment:add', { content: content})
  }) 

}

function commentTemplate(comment){
  return  `<li class='collection-item'>${comment.content}</li>`
}

function renderComment(comment){
  const renderedComment = commentTemplate(comment)
  document.querySelector('#comment-section').innerHTML += renderedComment
}

function renderComments(comments){
  const renderedComments = comments.map(comment=>commentTemplate(comment))

  document.querySelector('#comment-section').innerHTML = renderedComments.join('')
}

window.createSocket = createSocket
