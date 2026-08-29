@extends('layouts.app')

@section('content')
    <x-common.page-breadcrumb pageTitle="Support Chat" />

    <x-common.back-link :href="route('settings.index')" label="Back to Settings" />

    @if (! $firebaseProjectId || ! $firebaseWebApiKey)
        <x-common.component-card title="Support Chat">
            <p class="text-theme-sm text-gray-500 dark:text-gray-400">
                Set both <strong>Firebase Project ID</strong> and <strong>Web API Key</strong> on the
                <a href="{{ route('settings.firebase.edit') }}" class="text-brand-600 dark:text-brand-400 underline">Firebase Credentials</a> page first.
            </p>
        </x-common.component-card>
    @else
        <div class="grid grid-cols-1 gap-4 lg:grid-cols-[280px_1fr]" style="height: 70vh;">
            <div class="flex flex-col overflow-hidden rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-white/[0.03]">
                <div class="border-b border-gray-200 p-4 dark:border-gray-800">
                    <h3 class="font-semibold text-gray-800 dark:text-white/90">Conversations</h3>
                </div>
                <div id="conversation-list" class="flex-1 overflow-y-auto">
                    <p class="p-4 text-theme-sm text-gray-400">Loading…</p>
                </div>
            </div>

            <div class="flex flex-col overflow-hidden rounded-2xl border border-gray-200 bg-white dark:border-gray-800 dark:bg-white/[0.03]">
                <div id="thread-header" class="border-b border-gray-200 p-4 dark:border-gray-800">
                    <h3 class="font-semibold text-gray-800 dark:text-white/90">Select a conversation</h3>
                </div>
                <div id="message-list" class="flex-1 space-y-3 overflow-y-auto p-4"></div>
                <form id="send-form" class="flex items-center gap-2 border-t border-gray-200 p-3 dark:border-gray-800">
                    <input id="message-input" type="text" placeholder="Type a reply…" autocomplete="off" disabled
                        class="dark:bg-dark-900 h-11 flex-1 rounded-lg border border-gray-300 bg-transparent px-4 text-sm text-gray-800 shadow-theme-xs placeholder:text-gray-400 focus:border-brand-300 focus:outline-hidden focus:ring-3 focus:ring-brand-500/10 dark:border-gray-700 dark:bg-gray-900 dark:text-white/90" />
                    <button type="submit" disabled id="send-button"
                        class="flex h-11 items-center justify-center rounded-lg bg-brand-500 px-5 text-sm font-medium text-white hover:bg-brand-600 disabled:cursor-not-allowed disabled:opacity-50">
                        Send
                    </button>
                </form>
            </div>
        </div>

        <script type="module">
            import { initializeApp } from 'https://www.gstatic.com/firebasejs/10.13.2/firebase-app.js';
            import { getAuth, signInWithCustomToken } from 'https://www.gstatic.com/firebasejs/10.13.2/firebase-auth.js';
            import {
                getFirestore, collection, query, where, onSnapshot, orderBy, addDoc, serverTimestamp,
            } from 'https://www.gstatic.com/firebasejs/10.13.2/firebase-firestore.js';

            const app = initializeApp({
                apiKey: @json($firebaseWebApiKey),
                projectId: @json($firebaseProjectId),
            });
            const auth = getAuth(app);
            const db = getFirestore(app);

            const listEl = document.getElementById('conversation-list');
            const messageListEl = document.getElementById('message-list');
            const threadHeaderEl = document.getElementById('thread-header');
            const form = document.getElementById('send-form');
            const input = document.getElementById('message-input');
            const sendButton = document.getElementById('send-button');

            let activeConversationId = null;
            let unsubscribeMessages = null;

            function conversationLabel(id, participants) {
                const other = (participants || []).find((p) => p !== 'support_agent');
                return other ? other.replace('_', ' #') : id;
            }

            function openConversation(id, label) {
                activeConversationId = id;
                threadHeaderEl.innerHTML = `<h3 class="font-semibold text-gray-800 dark:text-white/90">${label}</h3>`;
                input.disabled = false;
                sendButton.disabled = false;
                messageListEl.innerHTML = '<p class="text-theme-sm text-gray-400">Loading…</p>';

                if (unsubscribeMessages) unsubscribeMessages();

                const messagesQuery = query(
                    collection(db, 'conversations', id, 'messages'),
                    orderBy('createdAt', 'asc'),
                );

                unsubscribeMessages = onSnapshot(messagesQuery, (snap) => {
                    messageListEl.innerHTML = '';
                    snap.forEach((doc) => {
                        const m = doc.data();
                        const mine = m.senderId === 'support_agent';
                        const bubble = document.createElement('div');
                        bubble.className = mine ? 'flex justify-end' : 'flex justify-start';
                        bubble.innerHTML = `<div class="max-w-[75%] rounded-2xl px-4 py-2 text-sm ${mine ? 'bg-brand-500 text-white' : 'bg-gray-100 text-gray-800 dark:bg-white/10 dark:text-white/90'}"></div>`;
                        bubble.firstChild.textContent = m.text || '';
                        messageListEl.appendChild(bubble);
                    });
                    messageListEl.scrollTop = messageListEl.scrollHeight;
                });
            }

            form.addEventListener('submit', async (e) => {
                e.preventDefault();
                const text = input.value.trim();
                if (! text || ! activeConversationId) return;
                input.value = '';
                await addDoc(collection(db, 'conversations', activeConversationId, 'messages'), {
                    senderId: 'support_agent',
                    text,
                    createdAt: serverTimestamp(),
                });
            });

            async function boot() {
                const res = await fetch(@json(route('settings.support-chat.token')), {
                    headers: { Accept: 'application/json' },
                });
                const { data } = await res.json();
                await signInWithCustomToken(auth, data.token);

                const conversationsQuery = query(
                    collection(db, 'conversations'),
                    where('participants', 'array-contains', 'support_agent'),
                );

                onSnapshot(conversationsQuery, (snap) => {
                    if (snap.empty) {
                        listEl.innerHTML = '<p class="p-4 text-theme-sm text-gray-400">No support conversations yet.</p>';
                        return;
                    }
                    listEl.innerHTML = '';
                    snap.forEach((doc) => {
                        const data = doc.data();
                        const label = conversationLabel(doc.id, data.participants);
                        const item = document.createElement('button');
                        item.type = 'button';
                        item.className = 'block w-full border-b border-gray-100 p-4 text-left text-theme-sm text-gray-700 hover:bg-gray-50 dark:border-gray-800 dark:text-gray-300 dark:hover:bg-white/5';
                        item.textContent = label;
                        item.addEventListener('click', () => openConversation(doc.id, label));
                        listEl.appendChild(item);
                    });
                });
            }

            boot().catch((err) => {
                console.error(err);
                listEl.innerHTML = '<p class="p-4 text-theme-sm text-error-500">Failed to load — check the browser console.</p>';
            });
        </script>
    @endif
@endsection
