

importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyB8_7HLDqHR28cHS0ybilC9S_oKY1XlMuk",
  authDomain: "tiktokclone-ccd81.firebaseapp.com",
  projectId: "tiktokclone-ccd81",
  storageBucket: "tiktokclone-ccd81.firebasestorage.app",
  messagingSenderId: "502683254609",
  appId: "1:502683254609:web:f383bcb131a56beb7c5d70",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((message) => {
  console.log("Received background message: ", message);
  const notificationTitle = message.notification?.title || "Default Title";
  const notificationOptions = {
    body: message.notification?.body || "Default body",
    icon: message.notification?.icon || "/default-icon.png",
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});






