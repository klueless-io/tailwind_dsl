
  // tailwind.config.js
  const colors = require('tailwindcss/colors')
  
  module.exports = {
    // ...
    theme: {
      extend: {
        colors: {
          'warm-gray': colors.warmGray,
          sky: colors.sky,
          cyan: colors.cyan,
        },
      },
    },
    plugins: [
      // ...
      require('@tailwindcss/forms'),
    ],
  }
  