<?php

test('the admin dashboard sends guests to the sign-in page', function () {
    $this->get('/')->assertRedirect(route('signin'));
});

test('the sign-in page is reachable by guests', function () {
    $this->get('/signin')->assertOk();
});
