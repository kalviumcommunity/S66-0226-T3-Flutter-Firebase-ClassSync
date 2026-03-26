/* eslint-disable no-undef */
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.13.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyA6lc3GmYUM1I67foFTg785dp_APBKm6BE',
  appId: '1:117768309220:web:3f3376f91c1461f64f5ff1',
  messagingSenderId: '117768309220',
  projectId: 'classsync-df2de',
  authDomain: 'classsync-df2de.firebaseapp.com',
  storageBucket: 'classsync-df2de.firebasestorage.app',
  measurementId: 'G-B74XC19X0B',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const notification = payload.notification || {};
  const title = notification.title || 'ClassSync Update';
  const options = {
    body: notification.body || 'You have a new notification.',
    icon: '/icons/Icon-192.png',
  };
  self.registration.showNotification(title, options);
});
