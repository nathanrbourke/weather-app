const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.html.erb'
  ],
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
      fontSize: {
        'h1': '2.25rem', // 36px
        'h2': '1.875rem', // 30px
        'h3': '1.5rem', // 24px
        'h4': '1.25rem', // 20px
        'h5': '1.125rem', // 18px
        'h6': '1rem', // 16px
        'p': '0.75rem', // 16px
        'small': '0.875rem', // 14px
      },
    },
  },
  plugins: [
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ]
}