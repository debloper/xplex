import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
  site: 'https://xplex.me',
  integrations: [
    starlight({
      title: 'xplex',
      logo: {
        src: './public/favicon.svg',
      },
      customCss: [
        './src/styles/custom.css',
      ],
      social: {
        github: 'https://github.com/debloper/xplex',
      }
    }),
  ],
  markdown: {
    // markdown configuration options
  },
  build: {
    // build configuration options
  },
});
