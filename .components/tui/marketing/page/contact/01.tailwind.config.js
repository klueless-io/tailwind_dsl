
  // tailwind.config.js
  const colors = require('tailwindcss/colors')
  
  module.exports = {
    // ...
    theme: {
      extend: {
        colors: {
          'warm-gray': colors.warmGray,
          teal: colors.teal,
        },
      },
    },
    plugins: [
      // ...
      require('@tailwindcss/forms'),
    ],
  }
  