/** @type {import('next').NextConfig} */
const nextConfig = {
    images: {
      domains: ['neoflames.com'], // Replace with your actual image domains
      deviceSizes: [640, 750, 828, 1080, 1200, 1920, 2048, 3840],
      imageSizes: [16, 32, 48, 64, 96, 128, 256, 384],
    },
    // Enable static exports if you're deploying to a static hosting
    // output: 'export', // Uncomment this line if you're deploying to a static host
  
    // Optionally, add custom webpack config
    webpack: (config, { isServer }) => {
      // Add any custom webpack configurations here
      return config
    },
  
    // Environment variables that will be available at build time
    env: {
      NEXTAUTH_URL: process.env.NEXTAUTH_URL,
    },
  
    // Add any other Next.js config options you need
  }
  
  module.exports = nextConfig