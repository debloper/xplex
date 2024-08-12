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
      tableOfContents: false,
      customCss: [
        './src/styles/custom.css',
      ],
      social: {
        github: 'https://github.com/debloper/xplex',
      },
      sidebar: [
        {
          label: 'Introduction',
          items: [
            'intro/index',
            'intro/internals',
          ],
        },
        {
          label: 'Installation',
          items: [
            'setup/index',
            'setup/docker',
            'setup/native',
          ],
        },
        {
          label: 'Invocation',
          items: [
            'usage/index',
            'usage/ingests',
            'usage/streaming',
          ],
        },
      ],
    }),
  ],
  markdown: {
    // markdown configuration options
  },
  build: {
    // build configuration options
  },
});
