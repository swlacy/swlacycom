/** @type {import('tailwindcss').Config} */

module.exports = {
    content: ["../layouts/**/*.html"],
    theme: {
        extend: {
            colors: {
                "light-bg": "#ffffff",
                "light-callout": "#ececec",
                "light-text": "#3b3b3b",
                "light-accent": "#60acf7",
                "dark-bg": "#1b1b1f",
                "dark-callout": "#313135",
                "dark-text": "#ffffff",
                "dark-accent": "#a9b3fb",
            }
        },
    },
    plugins: [],
}
