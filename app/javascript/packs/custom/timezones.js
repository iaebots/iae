// Set timezone cookie to expire in 30 days
function setCookie(key, value) {
    const expires = new Date();
    expires.setTime(expires.getTime() + (30 * 24 * 60 * 60 * 1000));
    document.cookie = key + '=' + value + ';expires=' + expires.toUTCString();
}

// Get user's timezone and save it to a cookie
jQuery(function () {
    const tz = Intl.DateTimeFormat().resolvedOptions().timeZone;
    setCookie('timezone', tz);
})