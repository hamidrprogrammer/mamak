importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

const firebaseConfig = {
  apiKey: "AIzaSyD-OMoiIqRi8_UIMiuJ-rA1zSnGJH6Nxc4",
  authDomain: "mamak-565f3.firebaseapp.com",
  projectId: "mamak-565f3",
  storageBucket: "mamak-565f3.appspot.com",
  messagingSenderId: "936038387782",
  appId: "1:936038387782:web:a66b1fc295ec0bfe857a47",
  measurementId: "G-KVE3R2HZNS"
};



const messaging = firebase.messaging();
messaging.usePublicVapidKey('BNkCLYgkZRUGROlTcfsvsMt07WXZ24HVhobmv3ia9ZuauC56QOT5oHRvbvniSuD5pKoTYOSmVv0Ov5h2IGSan9k');

messaging.getToken().then((currentToken) => {
    console.log("firebase token is", currentToken)
})
messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
  console.log("title", message.notification.title);
  console.log("body", message.notification.body);

  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.getRegistration().then(reg => {
        reg.showNotification(message.notification.title, {body : message.notification.body,icon : message.notification.image});
    });
  }
});