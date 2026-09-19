// Firebase Cloud Messaging service worker: shows the "new enquiry" push when
// the admin portal is not the focused tab, and focuses/opens the inbox on click.
//
// The config below is the same public web config already shipped in the app
// bundle (lib/core/firebase/firebase_options.dart) — it is not a secret.
// Messages are data-only (sent by supabase/functions/notify-new-lead) so this
// worker fully controls how the notification looks and where a click goes.
importScripts('https://www.gstatic.com/firebasejs/10.14.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.14.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyDfQwUi4gOZFdWL5HrvyHYzAhETo5NdwRI',
  appId: '1:663147332063:web:1fe6e8246b6679dd19c46a',
  messagingSenderId: '663147332063',
  projectId: 'gokul-portfolio-dbdda',
  authDomain: 'gokul-portfolio-dbdda.firebaseapp.com',
  storageBucket: 'gokul-portfolio-dbdda.firebasestorage.app',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const data = payload.data || {};
  return self.registration.showNotification(data.title || 'New enquiry', {
    body: data.body || '',
    icon: '/icons/Icon-192.png',
    tag: data.submissionId || 'new-enquiry',
    data: { url: data.url || '/#/admin' },
  });
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const target = new URL(event.notification.data.url, self.location.origin).href;
  event.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then((list) => {
      for (const client of list) {
        if (new URL(client.url).origin === self.location.origin && 'focus' in client) {
          return client.navigate(target).then((c) => (c || client).focus());
        }
      }
      return clients.openWindow(target);
    }),
  );
});
