importScripts('https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: "AIzaSyA3gPHrrKDMAhXwsr3C2nf3Y54s9YMlq4k",
  authDomain: "aircare-bdc4d.firebaseapp.com",
  projectId: "aircare-bdc4d",
  storageBucket: "aircare-bdc4d.firebasestorage.app",
  messagingSenderId: "868590221126",
  appId: "1:868590221126:web:736cba6c0c7ae4206a1747"
});

const messaging = firebase.messaging();
